output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.cluster.name
}

output "cluster_id" {
  description = "ECS cluster ID."
  value       = aws_ecs_cluster.cluster.id
}