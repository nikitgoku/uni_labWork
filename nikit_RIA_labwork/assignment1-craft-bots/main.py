import argparse
from agents.assignment_Agent import Assignment_Agent
from agents.PDDLInterface import PDDLInterface
from agents.rule_based_agent import RBAgent
from craftbots.simulation import Simulation
from gui.main_window import CraftBotsGUI

if __name__ == '__main__':

    # parse command line arguments
    arg_parser = argparse.ArgumentParser()
    arg_parser.add_argument('-f', help="configuration file", type=str, default='/home/nikit/labwork/uni_labWork/nikit_RIA_labwork/Assesment/craft-bots/craftbots/config/2022part1_configuration.yaml')
    args = arg_parser.parse_args()

    # Simulation
    sim = Simulation(configuration_file=args.f)

    # agent
    agent = Assignment_Agent()
    sim.agents.append(agent)
    sim.reset_simulation()
    #agent.get_next_commands_v1()
    #PDDLInterface.generatePlan("agents/domain-craft-bots.pddl", "agents/problem.pddl", "agents/plan.pddl", verbose=True)
    #PDDLInterface.readPDDLPlan("agents/plan.pddl")
    # GUI
    gui = CraftBotsGUI(sim)
    gui.start_window()

