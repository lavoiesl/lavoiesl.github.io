---
title: "LAMP Cluster — Distributed filesystem"
tags: ["Linux", "NFS", "Filesystem", "hosting", "GlusterFS", "Csync2", "Lustre", "DRBD", "sysadmin"]
date: 2013-04-13 17:49:00 -0400
---

This post is part of: [Guide to replicated LAMP stack hosting with failover](/2013/03/guide-to-replicated-lamp-stack-hosting-with-failover.html)

The core concept of choosing a filesystem for a Web hosting cluster is to eliminate single points of failure, but sometimes it is just not easy like that. A true distributed system will still need to be performant, at least on reads. The problem relies in the fact that the bottleneck if very often the I/O so if your filesystem is not performant, you will end up spending a fortune on scaling, without gaining real performance.

### Making priorities

You can’t have everything, so start by making a list of priorities. Different systems will have different needs, but I figured I could afford a possibility of failure as long as the system could be restorable since I would be keeping periodic backups.

1. Low maintenance
  - It must be possible to read/write from any folder without adding a manifest for each site.
  - The system must be completely autonomous and require no maintenance from a sysadmin. (Conflict management).
2. Simple / Cheap
  - Must be installed on each Web nodes or a maximum of 2 small/medium extra nodes
  - Must run on Ubuntu, without recompiling the kernel. Kernel modules are acceptable.
3. Performant
  - Reads less than 50% slower than standard ext3 reads.
  - Writes less than 80% slower than standard ext3 writes.
  - Must be good at handling a lot of small files. Currently, my server hosts 470k files for a total of 6.8 GB. That is an average of 15 KB per file!
4. ConsistencyChanges must propagate to all servers within 5 seconds.
  - Uploaded files stored in database but not yet synced may generate some errors for a short period if viewed by other users on other servers.
  - Temporary files are only relevant on the local machine so a delay is not a big deal.
  - HTTP Sessions will be sticky at the LodeBalancer level so user specific information will be handled properly.
5. Must handle ACLs
  - For permissions to be set perfectly, we will be using ACLs.
  - ACLs may not be _readable_ within the Web node, but they must still be enforced.
6. Durability
  - Must handle filesystem failures — be repairable very quickly.
  - File losses are acceptable in the event of a filesystem failure.
  - Filesystem must continue to function even if a Web node goes offline.
  - No single point of failure. If there is one, if must be isolated on its own machine.
  

### A. Synchronisation

Synchronisation means that there is no filesystem solution, all the files are stored on the local filesystem and synchronisation is made with the other nodes periodically or by watching I/O events.

Cluster synchronisation involving replication between all the nodes is usually very hard. To improve performance and reduce the risk of conflicts, it is often a good idea to elect a replication leader and a backup. If the leader is unavailable, the backup will be used instead. This way, all the nodes will sync with only one.

- Pros
  - Very fast read/write
  - Very simple to setup
- Cons
  - May have troubles synchronizing ACLs
  - May generate a lot of I/O
  - Will most likely generate conflicts

#### Rsync

The typical tool for fast file syncing is rsync. It is highly reliable and a bit of BASH scripting will get you started. However, as the number of files grows, it may become slow. For around a million files, it may easily take over 5 seconds. With our needs, it means it will have to run continuously, which will generate a lot of I/O and thus impact the overall performance.

#### [Csync2](http://oss.linbit.com/csync2/)

Csync2 is a promising tool that works like rsync, but it keeps file hints in a SQLite database. When a file changes, it flags in the database that the file needs checking. This way, the full sync only needs to check marked files.

Csync2 supports multi-master replication and slaves (receive-only). However, I found while testing that it is not really adapted to a lot of small files changing frequently: it tends to generate a lot of conflicts that need to be attended manually.

It may not be the best solution for Web hosting, but for managing deployment of libraries or similar tasks, it would be awesome.

### B. Simple sharing (NFS)

Even simpler than file syncing is plain old sharing. A node is responsible of hosting the files and serves the files directly. Windows uses Samba/CIFS, Mac uses AFP and Linux uses NFS.

NFS is very old, like 1989 old. Even the latest version, NFSv4, came around in 2000. This means it is very stable and very good at what it does.

- Pros
  - Supports ACLs (NFSv4)
  - Very cheap and simple setup
  - Up to a certain scale, fast read/write
- Cons
  - Single point of failure
  - Hard to setup proper failover
  - Not scalable



### C. Distributed / Replicated

A distributed filesystem may operate at a device, block or inode level. You can think of this a bit like a database cluster. It usually involves journals and is the most advanced solution.


- Pros
  - Very robust
  - Scalable
- Cons
  - Writes are often painfully slow
  - Reads can also be slow
  - Often complex to setup

#### [GlusterFS](http://www.gluster.org/)

Gluster runs over Fuse and NFS. Each node can have its own block and the daemon handles the replication transparently, without the needs of a management node. 

Overall, it is very good software, the write performance is decent and it handles failures quite well. There has been a lot of recent work to improve caching, async writes, write-ahead, etc.  However, in my experience, the read performance is disastrous. I really tried tuning it a lot, but I still feel like I haven’t  found the true potential of this. 

Ultimately, I had to let it down for the moment because of a lack of time to tune it more. It has a large community and is widely spread, so I will probably end up giving it another chance.

#### [Lustre](http://wiki.lustre.org/index.php/Main_Page)

Lustre seems like the Holy Grail of distributed filesystems. From [Wikipedia](http://en.wikipedia.org/wiki/Lustre_(file_system)): “At the present time, six of the top 10 and more than 60 of the top 100 supercomputers in the world have Lustre file systems in them.”

It appears to have everything I could dream of: speed, scalability, locks, ACLs, you name it. 

However, I was never able to try it. It requires dedicated machines with various roles: management, data, file servers (API). This means I would need 4-5 additional machines. On top of that, it needs custom kernel modules.

Definitely on my wish-list, but inaccessible for the moment.

#### [DRBD](http://www.drbd.org/)

DRBD is not cluster solution, it does live backup. Usually, it is used to make a full mirror of a server that can be swapped with the master at any moment, should it fail. This is often used to *patch* solutions where replication is not built-it. Examples of this are NFS or MySQL. There is a way to [setup a 3-nodes solution](http://www.drbd.org/users-guide/s-three-nodes.html), but it is far from perfect.

### Conclusion

In the end, I found that synced solutions were not reliable enough and distributed solutions were too complex so I chose NFS. My plan is to add a DRBD soon to provide a durability layer but a more serious solution will have to wait. If my cluster scales to the point that NFS can’t suffice to the task, this will mean I will have enough clients, enough money and enough reasons to consider a proper solution.


<table align="center" border="0" cellpadding="2" cellspacing="3" style="font-size: 0.9em; text-align: center; color: #f5f7fa;">
    <caption>Comparison</caption>
    <thead>
<tr>
            <th></th>
            <th>Maintenance</th>
            <th>Complexity</th>
            <th>Performance</th>
            <th>Scalability</th>
            <th>Durability</th>
            <th>Consistency</th>
            <th>ACLs</th>
        </tr>
</thead>
    <tbody>
<tr>
            <th>Rsync</th>
      <td bgcolor="#6f5b00">Low</td>
      <td bgcolor="#6f5b00">Low</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#6f5b00">Low</td>
      <td bgcolor="#1f6b3a">High</td>
      <td bgcolor="#8b1a1a">Low</td>
      <td bgcolor="#1f6b3a">Yes</td>
        </tr>
<tr>
            <th>Csync2</th>
      <td bgcolor="#8b1a1a">High</td>
      <td bgcolor="#6f5b00">Medium</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#6f5b00">Low</td>
      <td bgcolor="#1f6b3a">High</td>
      <td bgcolor="#8b1a1a">Low</td>
      <td bgcolor="#1f6b3a">Yes</td>
        </tr>
<tr>
            <th>NFS</th>
      <td bgcolor="#1f6b3a">None</td>
      <td bgcolor="#1f6b3a">None</td>
      <td bgcolor="#6f5b00">Medium</td>
      <td bgcolor="#8b1a1a">None</td>
      <td bgcolor="#8b1a1a">None</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#6f5b00">Enforced</td>
        </tr>
<tr>
            <th>GlusterFS</th>
      <td bgcolor="#1f6b3a">None</td>
      <td bgcolor="#6f5b00">Medium</td>
      <td bgcolor="#8b1a1a">Low</td>
      <td bgcolor="#1f6b3a">High</td>
      <td bgcolor="#1f6b3a">High</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#1f6b3a">Yes</td>
        </tr>
<tr>
            <th>Lustre</th>
      <td bgcolor="#1f6b3a">None</td>
      <td bgcolor="#8b1a1a">Very high</td>
      <td bgcolor="#1f6b3a">High</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#1f6b3a">Yes</td>
        </tr>
<tr>
            <th>DRBD</th>
      <td bgcolor="#1f6b3a">None</td>
      <td bgcolor="#6f5b00">Medium</td>
      <td bgcolor="#2f3542">n/a</td>
      <td bgcolor="#6f5b00">2 or 3</td>
      <td bgcolor="#1f6b3a">Very high</td>
      <td bgcolor="#2f3542">n/a</td>
      <td bgcolor="#1f6b3a">Yes</td>
        </tr>
</tbody>
</table>



