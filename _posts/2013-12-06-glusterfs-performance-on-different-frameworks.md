---
title: "GlusterFS performance on different frameworks"
tags: ["Wordpress", "Drupal", "Filesystem", "hosting", "GlusterFS", "Symfony2", "Performance", "sysadmin"]
date: 2013-12-06 23:46:00 -0500
---

A couple months ago, I did a [comparison of different distributed filesystems](http://blog.lavoie.sl/2013/04/lamp-cluster-distributed-filesystem.html). It came out that [GlusterFS](http://www.gluster.org/) was the easiest and most feature full, but it was slow. Since I would really like to use it, I decided to give another chance. Instead of doing raw benchmarks using [sysbench](http://sysbench.sourceforge.net/), I decided to stress test a basic installation of the three PHP frameworks/CMS I use the most using [siege](http://www.joedog.org/siege-home/).

My test environment:

- MacBook Pro (Late 2003, Retina, i7 2.66 Ghz)
- PCIe-based Flash Storage
- 2-4 virtuals machines using VMware Fusion 4, each with 2 GB of RAM.
- `Ubuntu 13.10 server edition with PHP 5.5 and OPCache enabled`
- GlusterFS running on all VMs with a volume in replica mode
- The volume was mounted using `nodiratime,noatime` using GlusterFS native driver (NFS was slower)


The test:<br>

```bash
siege -c 20 -r 5 http://localhost/foo    # Cache warming
siege -c 20 -r 100 http://localhost/foo  # Actual test
```

I then compared the local filesystem (inside the VM) vs the Gluster volume using these setups:

- 2 nodes, 4 cores per node
- 2 nodes, 2 cores per node
- 4 nodes, 2 cores per node

The compared value is the total time to serve 20 x 100 requests in parallel.<br>
All tests were ran 2-3 times while my computer was doing nothing and the results were very consistent.<br>
<br>
<table border="0" cellpadding="2" cellspacing="3" style="font-size: 0.9em; text-align: right; width: 100%;">
        <tbody>
<tr>
                <th></th>
                <th></th>
                <th style="text-align: right;">Symfony</th>
                <th style="text-align: right;">Wordpress</th>
                <th style="text-align: right;">Drupal</th>
                <th style="text-align: right;">Average</th>
            </tr>
<tr>
                <th rowspan="2" style="text-align: center;">2 nodes<br>
4 cores</th>
                <th style="text-align: center;">Local</th>
                <td bgcolor="#333" style="color: white;">2.91 s</td>
                <td bgcolor="#333" style="color: white;">9.92 s</td>
                <td bgcolor="#333" style="color: white;">5.39 s</td>
                <td bgcolor="#333" style="color: white;">6.07 s</td>
            </tr>
<tr>
                <th style="text-align: center;">Gluster</th>
                <td bgcolor="#333" style="color: white;">10.84 s</td>
                <td bgcolor="#333" style="color: white;">23.94 s</td>
                <td bgcolor="#333" style="color: white;">7.81 s</td>
                <td bgcolor="#333" style="color: white;">14.20 s</td>
            </tr>
<tr>
                <th rowspan="2" style="border-top: 1px solid #ccc; text-align: center;">2 nodes<br>
2 cores</th>
                <th style="border-top: 1px solid #ccc; text-align: center;">Local</th>
                <td bgcolor="#333" style="color: white;">5.41 s</td>
                <td bgcolor="#333" style="color: white;">19.14 s</td>
                <td bgcolor="#333" style="color: white;">9.67 s</td>
                <td bgcolor="#333" style="color: white;">11.41 s</td>
            </tr>
<tr>
                <th style="text-align: center;">Gluster</th>
                <td bgcolor="#333" style="color: white;">25.05 s</td>
                <td bgcolor="#333" style="color: white;">31.91 s</td>
                <td bgcolor="#333" style="color: white;">15.17 s</td>
                <td bgcolor="#333" style="color: white;">24.04 s</td>
            </tr>
<tr>

            </tr>
<tr>
                 <th rowspan="2" style="border-top: 1px solid #ccc; text-align: center;">4 nodes<br>
2 cores</th>
                <th style="border-top: 1px solid #ccc; text-align: center;">Local</th>
                <td bgcolor="#333" style="color: white;">5.57 s</td>
                <td bgcolor="#333" style="color: white;">19.6 s</td>
                <td bgcolor="#333" style="color: white;">9.79 s</td>
                <td bgcolor="#333" style="color: white;">11.65 s</td>
            </tr>
<tr>
                <th style="text-align: center;">Gluster</th>
                <td bgcolor="#333" style="color: white;">30.56 s</td>
                <td bgcolor="#333" style="color: white;">35.92 s</td>
                <td bgcolor="#333" style="color: white;">18.36 s</td>
                <td bgcolor="#333" style="color: white;">28.28 s</td>
            </tr>
<tr>

            </tr>
<tr>
                 <th rowspan="4" style="border-top: 1px solid #ccc; text-align: center;">Local vs<br>
Gluster</th>
                <th style="border-top: 1px solid #ccc; text-align: center;">2 nodes, 4 cores</th>
                <td bgcolor="#333" style="color: white;">273 %</td>
                <td bgcolor="#333" style="color: white;">141 %</td>
                <td bgcolor="#333" style="color: white;">45 %</td>
                <td bgcolor="#333" style="color: white;">153 %</td>
            </tr>
<tr>
                <th style="text-align: center;">2 nodes, 2 cores</th>
                <td bgcolor="#333" style="color: white;">363 %</td>
                <td bgcolor="#333" style="color: white;">67 %</td>
                <td bgcolor="#333" style="color: white;">57 %</td>
                <td bgcolor="#333" style="color: white;">162 %</td>
            </tr>
<tr>
                <th style="text-align: center;">4 nodes, 2 cores</th>
                <td bgcolor="#333" style="color: white;">449 %</td>
                <td bgcolor="#333" style="color: white;">83 %</td>
                <td bgcolor="#333" style="color: white;">88 %</td>
                <td bgcolor="#333" style="color: white;">206 %</td>
            </tr>
<tr>
                <th style="text-align: center;">Average</th>
                <td bgcolor="#8B3A62" style="color: white;">361 %</td>
                <td bgcolor="#8B3A62" style="color: white;">97 %</td>
                <td bgcolor="#8B3A62" style="color: white;">63 %</td>
                <td bgcolor="#8B3A62" style="color: white;">174 %</td>
            </tr>
<tr>
                <th rowspan="2" style="border-top: 1px solid #ccc; text-align: center;">2 nodes vs<br>
4 nodes</th>
                <th style="border-top: 1px solid #ccc; text-align: center;">Local</th>
                <td bgcolor="#1F4788" style="color: white;">3 %</td>
                <td bgcolor="#1F4788" style="color: white;">2 %</td>
                <td bgcolor="#1F4788" style="color: white;">1 %</td>
                <td bgcolor="#1F4788" style="color: white;">2 %</td>
            </tr>
<tr>
                <th style="text-align: center;">Gluster</th>
                <td bgcolor="#2D5016" style="color: white;">22 %</td>
                <td bgcolor="#2D5016" style="color: white;">13 %</td>
                <td bgcolor="#2D5016" style="color: white;">21 %</td>
                <td bgcolor="#2D5016" style="color: white;">19 %</td>
            </tr>
<tr>
                <th rowspan="2" style="border-top: 1px solid #ccc; text-align: center;">4 cores vs<br>
2 cores</th>
                <th style="border-top: 1px solid #ccc; text-align: center;">Local</th>
                <td bgcolor="#8B008B" style="color: white;">86 %</td>
                <td bgcolor="#8B008B" style="color: white;">93 %</td>
                <td bgcolor="#8B008B" style="color: white;">79 %</td>
                <td bgcolor="#8B008B" style="color: white;">86 %</td>
            </tr>
<tr>
                <th style="text-align: center;">Gluster</th>
                <td bgcolor="#8B6914" style="color: white;">131 %</td>
                <td bgcolor="#8B6914" style="color: white;">33 %</td>
                <td bgcolor="#8B6914" style="color: white;">94 %</td>
                <td bgcolor="#8B6914" style="color: white;">86 %</td>
            </tr>
</tbody>
    </table>
<br>

[Google spreadsheet](https://docs.google.com/spreadsheet/ccc?key=0Avw4c4aLV1RjdENET25WTVRsR0lCcGozUTduQ2huNWc)


Observations:

1. Red — **Wordpress** and **Drupal** have an acceptable loss in performance under Gluster, but **Symfony** is catastrophic.
2. Blue — The **local** tests are slightly slower when using 4 nodes vs 2 nodes. This is normal, my computer had 4 VMs running.
3. Green — The **gluster** tests are 20% slower on a 4 node setup because there is more communication between the nodes to keep them all in sync. 20% overhead for double the nodes isn’t that bad.
4. Purple — The **local** tests are 85% quicker using 4 cores vs 2 cores. A bit under 100% is normal, there is always some overhead to parallel processing.
5. Yellow — For the **Gluster** tests, **Symfony** and **Drupal** scale very well with the number of nodes, but **Wordpress** is stalling, I am not sure why.


I am still not sure why **Symfony** is so much slower on GlusterFS, but really, I can’t use it in production for the moment because I/O is already the weak point of my infrastructure. I am in the process of looking for a different hosting solution, maybe it will be better then.
