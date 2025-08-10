import http.server
import os
import socketserver
import threading
import time
import sys
from pathlib import Path
from bs4 import BeautifulSoup

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options


SITE_DIR = Path("_site").resolve()
PORT = 4000
BASE_URL = f"http://127.0.0.1:{PORT}"


def find_mermaid_pages(site_dir: Path):
    pages = []
    for html_path in site_dir.rglob("*.html"):
        try:
            with html_path.open("r", encoding="utf-8", errors="ignore") as f:
                soup = BeautifulSoup(f.read(), "html.parser")
        except Exception:
            continue
        # Mermaid may be authored as <div class="mermaid">… or code blocks transformed by plugins
        if soup.select(".mermaid") or soup.select("pre code.language-mermaid"):
            rel = html_path.relative_to(site_dir)
            url = BASE_URL + "/" + str(rel).replace(os.sep, "/")
            pages.append(url)
    return pages


class SilentHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, format, *args):
        pass


def start_server():
    os.chdir(SITE_DIR)
    handler = SilentHandler
    httpd = socketserver.TCPServer(("", PORT), handler)
    t = threading.Thread(target=httpd.serve_forever, daemon=True)
    t.start()
    return httpd


def main():
    if not SITE_DIR.exists():
        print("_site directory not found. Build the site before running this check.", file=sys.stderr)
        sys.exit(2)

    httpd = start_server()
    time.sleep(0.5)

    pages = find_mermaid_pages(SITE_DIR)
    if not pages:
        print("No Mermaid diagrams found in built site. Skipping check.")
        httpd.shutdown()
        sys.exit(0)

    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-gpu")
    options.add_argument("--disable-dev-shm-usage")

    with webdriver.Chrome(options=options) as driver:
        failures = []
        for url in pages:
            try:
                driver.get(url)
                # Wait for Mermaid to render SVGs inside any .mermaid container
                WebDriverWait(driver, 15).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, ".mermaid svg"))
                )
                # Basic sanity: ensure at least one rendered diagram is visible
                svgs = driver.find_elements(By.CSS_SELECTOR, ".mermaid svg")
                if not svgs:
                    raise RuntimeError("No rendered Mermaid SVG found")
            except Exception as e:
                failures.append((url, str(e)))

        httpd.shutdown()

        if failures:
            print("Mermaid rendering check failed on the following pages:")
            for url, err in failures:
                print(f" - {url}: {err}")
            sys.exit(1)
        else:
            print(f"Mermaid rendering check passed on {len(pages)} page(s).")


if __name__ == "__main__":
    main()

