---
title: "Track your time working on PHP projects"
tags: ["Development tool", "Management", "Meta", "PHP", "Time tracking"]
date: 2013-01-31 02:07:00 -0500
---

Have you ever had a project manager? You know, the kind of person that comes to bug you about your timesheet not being properly done and how important it is? Well, as annoying as they can be, we must thank them and give them credit because it is indeed important. Even if you are a freelancer, you want to know roughly how much time you spent on a project to know if you billed the client correctly.

For years I hated timesheets. I am not particularly thorough at doing them either, so it just gets worse and worse. Fear not, I think I may have found a neat solution. The idea is to track when a PHP file is executed and log which project it belongs to.

To use my script, just follow the instructions in comments, but basically you will add it as a `auto_prepend_file` in your `php.ini` and it will check if the current script is watched and to which project it belongs to.

It is using a very basic file structure without even writing content. It is simply creating folder and files so you should not see the overhead. In fact, I tested that it creates an overhead of only about **0.3ms** (on a SSD).

It also has a threshold to count as continuous several minutes without activity (more details in comments).

So lets say you have this structure:

```
/var/www/client-A/project-1
/var/www/client-A/project-2
/var/www/client-B/project-1
```

Well with this script, configured to watch folder `/var/www`, any PHP called in it would be tracked and you would end up with something like:

- 2013-01-30
	- client-A
		- project-1: Time: 3:30
		- project-2: Time: 1:30
	- client-B
		- project-1: Time: 2:00
- 2013-01-31
	- client-B
		- project-1: Time: 8:30

Very very useful to build timesheets.

### Downside

Now, of the people I have showed this, a lot have said that it tracks a too narrow portion of site development. From what I am used to, I have to disagree. Here's a breakdown of events that would be tracked:
- Looking or configuring the CMS
- Testing some CSS/JS/HTML/PHP
- Testing a new plugin
- An AJAX request that runs on the page

And what would not:

- Developing a complicated library
- Documenting
- Designing

Well, I rarely design, it’s someone else who does it. Developing a complicated library? It is kinda rare, and when I do, it is linked to some project and I will end up testing it at the same time anyway. The real issue is documentation, but I tend to write it as I go. The threshold helps prevent those events won't be noticed, but in the end, the tool is meant to help, not to be an exact representation of your time.

{% highlight php linenos %}
<?php
# time-spender-logger.php
/**
 * On each PHP request (cli, cgi or apache module), 
 * this script will detect to which project the file belongs and log it.
 * It also features a threshold so a couple consecutive minutes without a request
 * doesn't stop your timer, see below.
 * 
 * To install, configure the roots (see below) add this line to your php.ini:
 * auto_prepend_file=/path/to/file/time-spender-logger.php
 * 
 * Call this file directly to output your data so far.
 * 
 * This was done to track my time on each of my projects.
 * 
 * The weird class name is to ensure no name collision will occur.
 * 
 * @link http://blog.lavoie.sl/2013/01/track-your-time-working-on-php-projects.html
 */
class __TimeSpenderLogger
{
    private $script;
    private $datadir;

    /**
     * Number of minutes that are consired continuous
     * For example, if a script runs at:
     *  - 5:10
     *  - 5:12
     *  - 5:45
     *  - 5:50
     * it will be counted as (12 - 10 + 1) + (50 - 45 + 1) = 9 minutes
     */
    public $threshold = 10;

    /**
     * Roots are folders that contain your projects.
     * All the folders directly below are considered project names
     * You can specify multiple roots for different project groups
     * Must be an absolute path.
     * They are checked in order so you may have a path that is inside another
     * Ex: array(
     *  'dev'     => '/var/www/dev'
     *  'general' => '/var/www'
     * )
     * 
     * For example, if script /var/www/my-project/foo/bar.php is ran, it will be logged as:
     * group: general   project: my-project
     */
    public $roots = array(
        'Sites' => '/Users/seb/Sites',
    );

    public function __construct()
    {
        $this->script   = realpath($_SERVER['SCRIPT_FILENAME']);
        $this->datadir  = dirname(__FILE__) . '/data';
    }

    private static function startsWith($haystack, $needle)
    {
        return !strncmp($haystack, $needle, strlen($needle));
    }

    /**
     * @return array containing [group, project]
     */
    private function getProject()
    {
        foreach ($this->roots as $group => $root) {
            if (self::startsWith($this->script, $root)) {
                $project = substr($this->script, strlen($root) + 1);

                $trim = strpos($project, '/');
                if ($trim > 1) {
                    // If a slash was not found, it is because the script is directly under the root.
                    // The project will therefore be the filename itself. ie: index.php
                    $project = substr($project, 0, $trim);
                }
                if (empty($project)) {
                    // This is just to prevent further errors, shouldn't happen
                    $project = 'none';
                }

                return array($group, $project);
            }
        }

        return false;
    }

    /**
     * Touches a file at $datadir/$group/$project/Y-m-d/H-i
     * This is the critical function because it does I/O
     */
    public function log()
    {
        $project = $this->getProject();
        if (empty($project)) return;

        $date = date('Y-m-d');
        $time = date('H-i');
        $folder = "{$this->datadir}/{$project[0]}/{$project[1]}/$date";

        is_dir($folder) || mkdir($folder, 0777, true);
        touch("$folder/$time");
    }

    /**
     * Loops through all the folder and compiles the minutes spent on each project
     */
    public function getData()
    {
        if (!is_dir($this->datadir)) return array();

        $data = array();

        foreach (scandir($this->datadir) as $group) {
            if ($group[0] == '.') continue;

            foreach (scandir("{$this->datadir}/$group") as $project) {
                if ($project[0] == '.') continue;

                foreach (scandir("{$this->datadir}/$group/$project") as $date) {
                    if ($date[0] == '.') continue;

                    $minutes = 0; // total minutes for this day, first is not counted, so add one
                    $counter = 0; // total consecutive minutes
                    $last = null; // last minute that was checked

                    foreach (scandir("{$this->datadir}/$group/$project/$date") as $time) {
                        if ($time[0] == '.') continue;

                        list($hour, $minute) = explode('-', $time);
                        $m = $hour * 60 + $minute;
                        $diff = (null == $last) ? 1 : $m - $last;

                        if ($diff <= $this->threshold) {
                            // increment counter
                            $counter += $diff;
                        } else {
                            // add the counter and reset
                            $minutes += $counter;
                            $counter = 1;
                            $last = null;
                        }

                        $last = $m;
                    }
                    $minutes += $counter;

                    $data[$date][$group][$project] = $minutes;
                }
            }
        }

        return $data;
    }

    /**
     * Displays the data in 4 neatly formatted columns: date, group, project and time
     * Note that projects and projects group have a max of 20 chars
     */
    public function show($data)
    {
        header('Content-Type: text/plain');
        printf("%-15s %-20s %-20s %5s\n", 'DATE', 'GROUP', 'PROJECT', 'TIME');
        $line = str_repeat('-', 15 + 1 + 20 + 1 + 20 + 1 + 5) . "\n";
        echo $line;

        foreach ($data as $date => $groups) {
            foreach ($groups as $group => $projects) {
                foreach ($projects as $project => $minutes) {
                    $hours = floor($minutes / 60);
                    $minutes -= $hours * 60;
                    printf("%-15s %-20s %-20s %2d:%02d\n", $date, $group, $project, $hours, $minutes);
                }
            }
            echo $line;
        }
    }

    /**
     * Runs the logger
     * If the script is directly called, prints the data instead
     */
    public static function run()
    {
        $instance = new self();

        if ($instance->script == __FILE__) {
            $instance->show($instance->getData());

            // Ensure we won't re-run this file a second file 
            // Happens if you are using auto_prepend_file
            die();
        } else {
            $instance->log();
        }
    }
}

__TimeSpenderLogger::run();
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/4680788)
