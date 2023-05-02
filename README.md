# Arma-3-External-Script-Executor
## Goal
The first goal with this executor was getting a better understanding of the SQF engine running in arma, and being able to execute code on a server.
Later on with the implementation of Copying and Placing pointers, we realized that this could be used to potentially "Hijack" a function and run our code, being able to do full detours in SQF.

###NOTE:
- I don't know if this has been done before, but to my knowledge, it has not been done before.

## Purpose
The purpose of this tool was to do the following:
- Execute SQF Code through a RSCDisplay.
- Inspect Scripts running in the Scheduler
- Inspect Variables located in the MissionNamespace.
- Inspect description.ext.

## Abilities
This tool has the power to do following:
- Execute SQF Code.
- Inspect Scripts in Scheduler
- Toggle Scripts in Scheduler
- Inspect Variables
- Change Variables
- Change Ptr to Variables Data
- Restore Ptr to Variables Data
