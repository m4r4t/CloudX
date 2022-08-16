resource "aws_cloudwatch_dashboard" "cloudX" {
  dashboard_name = "CloudX-LAB-Dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "AutoScalingGroupName",
            "${aws_autoscaling_group.ghost.name}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EFS",
            "ClientConnections",
            "FileSystemId",
            "${aws_efs_file_system.ghost.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "EFS ClientConnections"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EFS",
            "StorageBytes",
            "StorageClass",
            "Total",
            "FileSystemId",
            "${aws_efs_file_system.ghost.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "EFS StorageBytes"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/RDS",
            "CPUUtilization",
            "DBInstanceIdentifier",
            "${aws_db_instance.ghost.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "RDS CPUUtilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/RDS",
            "DatabaseConnections",
            "DBInstanceIdentifier",
            "${aws_db_instance.ghost.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "DatabaseConnections"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/RDS",
            "ReadIOPS",
            "DBInstanceIdentifier",
            "${aws_db_instance.ghost.id}"
          ],
          [
            "AWS/RDS",
            "WriteIOPS",
            "DBInstanceIdentifier",
            "${aws_db_instance.ghost.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "RDS IOPS"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "CPUUtilization",
            "ClusterName",
            "${aws_ecs_cluster.ghost.name}",
            "ServiceName",
            "${aws_ecs_service.ghost.name}"
          ]        
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "ECS CPUUtilization"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/ECS",
            "RunningTaskCount",
            "ClusterName",
            "${aws_ecs_cluster.ghost.name}",
            "ServiceName",
            "${aws_ecs_service.ghost.name}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "${data.aws_region.current.name}",
        "title": "ECS RunningTaskCount"
      }
    }
  ]
}
EOF
}