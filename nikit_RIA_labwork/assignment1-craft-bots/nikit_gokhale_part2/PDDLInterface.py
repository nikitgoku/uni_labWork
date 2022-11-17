from collections.abc import Set
from typing import List, Tuple, Union
import requests
import re
import random

class PDDLInterface:

    COLOURS = ['red', 'blue', 'orange', 'black', 'green']
    ACTIONS = ['move', 'mine', 'pick-up', 'drop', 'start-building', 'deposit', 'complete-building']

    @staticmethod
    # Function to write a problem file
    # Complete this function

    def writeProblem(world_info, file="agents/problem.pddl"):
        # Function that will

        with open(file, "w") as f:

            f.write("(define(problem craft-bots-problem)\n")
            f.write("(:domain craft-bots)\n")

            # Starting with the :objects area
            f.write("(:objects\n ")

            # Actors in the problem file
            for actor in world_info['actors']:
                f.write("a"+str(actor)+" ")
            f.write("- actor\n ")

            # Nodes in the problem file
            for node in world_info['nodes']:
                f.write("node"+str(node)+" ")
            f.write("- nodes\n ")

            # Mines in the problem file
            for mine in world_info['mines']:
                f.write("mine"+str(mine)+" ")
            f.write(" - mines\n ")

            # Resources in the problem file
            resources = {'red':0, 'blue':1, 'green':2, 'orange':3, 'black':4}
            
            for resource in resources.keys():
                f.write(str(resource)+" ")
            f.write("- resource\n ")

            # Buildings in the problem file
            for building in world_info['tasks']:
                f.write("building"+str(building)+" ")
            f.write(" - building\n")
            
            f.write(")\n\n")
            # --------Closing the :object area------------------

            # --------Starting with the :init area--------------
            f.write("(:init\n ")

            # Inititlizing actors
            for actor in world_info['actors']:
                f.write("(idle a"+str(actor)+")\n ")
            f.write("\n ")

            # Initializing actors' locations
            actorNodes = [node for node in world_info['nodes']]
            # to randomize the node allocation to the actors 
            random.shuffle(actorNodes)
            for actor, node in zip(world_info['actors'], actorNodes):
                f.write("(alocation a"+str(actor)+" node"+str(node)+")\n ")
            f.write("\n ")

            # Actor's inventory space
            for actor in world_info['actors']:
                f.write("(= (inventory_space a"+str(actor)+") 7)\n ")
            f.write("\n ")

            # Initializing node connections
            # Including two nodes at the same time
            listofNodes  = [node for node in world_info['nodes']]
            node_list1 = [[listofNodes[i], listofNodes[i+1]] for i in range(len(listofNodes)-1)]
            node_list2 = [[listofNodes[i+1], listofNodes[i]] for i in range(len(listofNodes)-1)]

            for nodei, nodej in node_list1:
                f.write("(adjacent node"+str(nodei)+" node"+str(nodej)+")\n ")
            f.write("\n ")

            for nodei, nodej in node_list2:
                f.write("(adjacent node"+str(nodei)+" node"+str(nodej)+")\n ")
            f.write("\n ")

            # Initializing mine resources
            for mine in world_info['mines']:
                f.write("(mfree mine"+str(mine)+")\n ")
            f.write("\n ")

            # Initializing mine location # Have to randomly shuffle the nodes
            # to randomize the node allocation to the actors
            random.shuffle(actorNodes)
            for mine, node in zip(world_info['mines'], actorNodes):
                f.write("(mlocation "+"mine"+str(mine)+" node"+str(node)+")\n ")
            f.write("\n ")

            # Initializing mine resources
            for mine, resource in zip(world_info['mines'], resources.keys()):
                if resource == 'orange':
                    f.write("(orangeResourcemine mine"+str(mine)+" "+resource+")\n ")
                if resource == 'red':
                    f.write("(redResourcemine mine"+str(mine)+" "+resource+")\n ")
                else:
                    f.write("(mineResource mine"+str(mine)+" "+resource+")\n ")
            f.write("\n ")

            # Initializing resources
            for resource in resources.keys():
                if resource == 'red':
                    f.write("(at 2 (redResource "+resource+"))\n ")
                    f.write("(at 120 (not (redResource "+resource+")))\n ")
                else:
                    f.write("("+resource+"Resource "+resource+")\n ")
            f.write("\n ")

            # Initializing the resource size
            for resource in resources.keys():
                if resource == 'black':
                    f.write("(= (resource_size "+resource+") 7)\n ")
                else:
                    f.write("(= (resource_size "+resource+") 1)\n ")
            f.write("\n ")

            # Initializing building resources at sites
            for node in world_info['nodes']:
                f.write("(= (build_resources_at_site node"+str(node)+") 0)\n ")
            f.write("\n ")

            # Initialzing construction status
            # to randomize the node allocation for the building
            buildingNodes = [node for node in world_info['nodes']]
            random.shuffle(buildingNodes)
            for building, node in zip(world_info['tasks'], buildingNodes):
                f.write("(= (construction_status building"+str(building)+" node"+str(node)+") 0)\n ")
            f.write("\n ")

            f.write(")\n\n")
            # ---------Closing the :init area--------------------

            # ----------Starting with the :goal area-------------
            f.write("(:goal (and\n ")

            # Writing our goal states
            for building, node in zip(world_info['tasks'], buildingNodes):
                f.write("(constructed building"+str(building)+" node"+str(node)+")\n ")
                break
            f.write(")\n)\n")
            # ---------Closing the :goal area--------------------

            f.write(")\n")
            f.close()

    @staticmethod
    def readPDDLPlan(file: str):
        # Completed already, will read a generated plan from file
        plan = []
        with open(file, "r") as f:
            line = f.readline().strip()
            while line:
                tokens = line.split()
                action = tokens[1][1:]
                params = tokens [2:-1]
                # remove trailing bracket
                params[-1] = params[-1][:-1]
                # remove character prefix and convert colo
                params = [int(re.findall(r'\d+', p)[0]) if p not in PDDLInterface.COLOURS else PDDLInterface.COLOURS.index(p) for p in params]
                plan.append((action, params))
                line = f.readline().strip()
            f.close()
        print("EVENT: Plan Read!")
        return plan

    @staticmethod
    # Completed already
    def generatePlan(domain: str, problem: str, plan: str, verbose=False):
        data = {'domain': open(domain, 'r').read(), 'problem': open(problem, 'r').read()}
        resp = requests.post('https://popf-cloud-solver.herokuapp.com/solve', verify=True, json=data).json()
        if not 'plan' in resp['result']:
            if verbose:
                print("WARN: Plan was not found!")
                print(resp)
            return False
        with open(plan, 'w') as f:
            f.write(''.join([act for act in resp['result']['plan']]))
        f.close()
        print("EVENT: Plan Generated!")
        return True

if __name__ == '__main__':
    PDDLInterface.generatePlan("agents/domain-craft-bots.pddl", "agents/problem.pddl", "agents/plan.pddl", verbose=True)
    plan = PDDLInterface.readPDDLPlan('agents/plan.pddl')
    print(plan)