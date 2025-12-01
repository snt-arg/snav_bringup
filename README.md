# snav_bringup

Repository to setup situationally aware path planning from setup to execution on robot.

## Run a real dataset

Real datasets need both the semantic graph and the metric map obtained from `voxblox` by integrating the LIDAR measurements. One particularity here was that (back then) s_graphs was lacking the capability to handle doorways. To work around this problem, even for real datasets, the semantic information is hand-crafted (resp. generated from the BIM if available).

If you have both the metric map `.voxblox` and the semantic graph (the csv files), things are very simple.

Let's load the Urchet dataset (RF1).

1. Configure the `is_graphs.launch`

```
<param name="wall_file_path" value="$(find is_graphs)/csv/floorplan/floorplan_urchet_walls.csv"/>
<param name="room_file_path" value="$(find is_graphs)/csv/floorplan/floorplan_urchet_rooms.csv" />
<param name="door_file_path" value="$(find is_graphs)/csv/floorplan/floorplan_urchet_doors.csv" />
```

2. mprocs: launch `IS_graph`
3. mprocs: launch `rviz`
4. mprocs: launch `carta_rt`
5. mprocs: launch `navigator_hl`
6. mprocs: launch `navigator_sgraphs`
   Now in rviz you will see the contours of the metric-semantic graph (you may have to zoom), but without the metric map. Let's load it by calling the `/carta/load_map_and_update` pointing it to our map e.g., `/some/path/urchet_flat.voxblox`. Now you should have both the semantic-metric layer and the metric map.
