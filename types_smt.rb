require 'httparty'

cubelets = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=smt_cubelets", headers: {'accept'=>"application/json"}).body)
moss = JSON.parse(HTTParty.get("http://tasks.internal.modrobotics.com/task_types?tag=smt_moss", headers: {'accept'=>"application/json"}).body)

TYPES = [
         {title: 'Cubelets SMT', types: cubelets},
         {title: 'MOSS SMT', types: moss}
        ]
