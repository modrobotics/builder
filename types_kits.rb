require 'httparty'

box_cubelet = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=box_cubelet", headers: {'accept'=>"application/json"}).body)
malc = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=malc", headers: {'accept'=>"application/json"}).body)
final_moss = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=final_moss", headers: {'accept'=>"application/json"}).body)
kitting = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=kitting", headers: {'accept'=>"application/json"}).body)
huck = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=huck", headers: {'accept'=>"application/json"}).body)

TYPES = [
         {title: 'Box Cubelets', types: box_cubelet}, 
         {title: 'Box MOSS Units', types: malc}, 
         {title: 'MOSS Non-Boxed Submission', types: final_moss}, 
         {title: 'Kits', types: kitting},
         {title: 'Huck Tank', types: huck}
        ]
