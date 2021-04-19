# LITARGIE Narrative
## Prompt
> In the midst of COVID-19, and social distancing, it is more important than ever to connect with friends and family, find ways to manage your stress, and take good care of yourself. Make a game that addresses one of these issues.

## Synopsis
The player wakes as the ego of their host: an avatar within the host's mindscape. They hear a voice from beyond: "*They* rest on your shoulders now." The player is tasked with navigating the world before them, sending memories to the host in order to rejuvenate them and remind them of what they *live* for.

## Writing Dungeon
We're taking inspiration from *Celeste*: confronting the avatar of the player's psyche and getting some messege from it. As it stands right now, the player plays as their *ego*, a balancing force between their *id* and *super-ego*, innate carnal desires and societal influence respectively. However, the player has *no impetus* to interact or care for these forces because we haven't established the host's predicament in universe.

### Establishing the Problem
The *proposed* problem is that the host, in the midst of the COVID-19 pandemic, has realized that their social contacts were limited to convention rather than actual friendships. In other words, whatever social interaction the host had, it was the result of *circumstance*, not because they formed legitimate relationships. 

The issue is that we have no *mechanical* way to introduce this problem without complete abuse of the DialogueManager.

However, we do have FloatingObject, and should be able to give it a "dialogue" parameter and send that to the DialogueManager. This solves two problems:
    1. We give the player a collectable to search and strive for.
    2. We give the player *optional* narrative information from these collectables.

Second, we can make the super-ego a psuedo-boss, chasing the player around the final level by matching its velocity on a delay, similar to Badeline from *Celeste.*

Third, we can abuse the DialogueManager using DialogueSpots and ConnectionPoints.

- [ ] Create Dialogue(d) Floating Objects
- [ ] Code super-ego trailing logic.
- [ ] Write mainstream dialogue.

### Solving the Problem
How do we *solve* the proposed issue while making use of concepts such as the host, ego, id, and super-ego?
This is a *platformer*, so we ought to construct a narrative surrounding *challenge.* The problem can be established through progressive use of FloatingObjects, DialogueSpots, and ConnectionPoints, but we'll list some primary lines here. The focus here is to establish (1) the relationship the ego has with the host, id, and super-ego, (2) the mental and physical state of the host, and (3) what keeping us from helping the host.

#### Chapter 1
##### Dialogue 1A
When the player spawns in: 
    - Unknown: "They rest on your shoulders now." 
The player can walk forward, following the tutorial.

##### Dialogue 1B
At the first campfire:
    - Unknown: "Our host... your absence has damaged them."
        - Branch:
            - Ego: "How?"
                - Unknown: "There's been something of a...[pause] pandemic in the real world. The host just can't cope."
    - Unknown: "In any case, the host has forgotten that they are, in fact, not an island. They need people, but reminders of them first.""
        - Branch:
            - Ego: "Island?"
                - Unknown: "People are innately social. Friends and family are unparalleled in their ability to heal mental wounds. The host needs them."
            - Ego: "Reminders?"
                - Unknown: "It's normal for memories to be tainted by bitterness, but it is on us to shine them and use them as fuel. [break] Show the host their memories."
    - Unknown: "Get going now. [pause] You'll find me soon enough."

##### Dialogue 1C
At this point, the player is standing before the *hook* (Meathook). 
- Unknown: "*That* [pause] is yours."
- Unknown: "Take it."

#### Dialogue 1D
The player has now activated the connection points, and is told by *Unknown* how to use them:
    - Unknown: "*Those* are connection points. They send memories to our host."
        - Ego: "What memories?"
    - Unknown: "Whatever ones you pick."
    - Unknown: "Go on."
        - "Friends."
            - Memory: "The host sees their past friends in their mind's eye: the joy of being around them, the support they can provide."
        - "Family."
            - Memory: "The host sees their family in their mind's eye: the comfort they bring, the unconditional love they provide."
        - "Self."
            - Memory: "The host sees themselves--a reflection of how others perceive them. They see a distant adult, full of potential."
    - Unknown: "See? Simple. Go on, find more."

#### Chapter 2
At this point, the player has knowledge of:
    1. The nature of their avatar.
    2. Their goal as the ego.
    3. The fact that a pandemic has uprooted their host's life in some way.
However, the player most likely has questions about:
    1. Who they are talking to.
    2. What is *exactly* wrong with the host.

##### Dialogue 2A
The player has cleared a gap, but has yet to reach a checkpoint.
    - Unknown: "This world that you traverse is the host's mind."
    - Unknown: "As you can tell, it's not... hospitable."
        - Ego: "What happened?"
            - Unknown: "Uncertainty. Anxiety. Small doses of depression. A crippling nicotine addiction."
            - Unknown: "Who would've thought a mere pandemic and social isolation could cause that, right?"

##### Dialogue 2B
The player has reached a campfire.
    - Unknown: "Despite those flaws, though, the host lives. It's our job to keep it that way--primarily through memories."
        - Ego: "Who are we?"
            - Id: "We're a part of them: the host."

##### Dialogue 2C 
The player is at the last campfire.
    - Id: "We're nearing a connection point. Keep going." 

##### Dialogue 2D
The player is at the connection point. 

Id: "This one is real: the last point was easy, this one not so much."
Id: "Go on, convince the host with their own past."

TERMINAL: "You peer into the point's orb and see the host clung to a corner of their room."
TERMINAL: "Strung on the ground is an assortment of pictures, bills, and a prescription bottle."
TERMINAL: "What memory would you like to remind the host of?"
    - "Pride"
        + TERMINAL: "You remind the host of their past work: the blood, sweat, and tears dumped into their hobby projects."
        + TERMINAL: "Seeing what they're capable of, the host is filled with determination."
    - "Trust"
        + TERMINAL: "Peering closer into the orb, you see a polaroid of the host and what seems to be a significant other."
        + TERMINAL: "You remind the host that they have someone to depend on--someone to trust."
        + TERMINAL: "Picking up the polaroid, the host is overcome with a sense of comfort."
    - "Security"
        + TERMINAL: "You remind the host that while they've gone through this before, it's safer with others."
        + TERMINAL: "You manifest on image of their mother."
        + TERMINAL: "Dialing their mother's phone number, the host is blanketed with a feeling of safety."

Id: Well done. Let's move on.

#### Chapter 3
We can probably take it to more extremes now.

##### Dialogue 3A
- Id: "The farther we go, the more hostile the mind gets."
- Id: "Keep moving forward."

##### Dialogue 3B
- Id: "Then again, the hostility means more of these. Go on."

##### Dialogue 3C
The player has come upon a connection point out in the open. They link it.
- "> Before you is a vision of the host, walking into their room."
- "> They're tired: worn from a day's work. They can't work on their project like this"
    - "Project?"
        - "> You peer into their memories: you see a dream project--in the making for a few months now."
            - "Remind them of pride."
                - "The host is reminded of the pride of a completed project--no matter how shoddy it is."
                - "They put their fatigue behind them and get to work--no matter how little it is."
            - "Remind them of joy."
                - "The host is reminded of the joy of creation."
                - "They put their fatigue behind them and begin crafting worlds, stories, and characters. It puts them at ease."
    - "Work?"
        - "> You peer into their memories: you see an office space, sterile as can be."
        - "> The long work hours taint the memory--but the host sees opportunity for friends here."
            - "Focus on friends."
                - "You remind a host of a small, yet important step in maintaining themselves: going out to lunch with coworkers."
                - "The host is filled with determination. 'Baby steps', they say."
            - "Dear god we want to quit."
                - "You remind the host that work isn't their life. They have people to fall back on."
                - "The host contemplates going back home--taking care of themselves for the better."
- Id: "See? You're beginning to exert more influence. Their circumstances can be changed."

#### Chapter 4

##### Chapter 4A
- Id: "This is it. The final connection point."
- Id: "The host has been making some improvements as we traverse their mind."
- Id: "It's time for you to hit the nail on the head. Make a choice."

- "Select a memory."
    - "Last night."
        - "> You remind the host of their previous night: how they failed to maintain a sleep schedule for the 75th time."
        - "> But, you remind them that it's ok. Failure simply means to try again."
    - "That coworker."
        - "> You remind the host of their coworker: the hints of humor and joy they bring to the space."
        - "> The host has thought of confiding in them... but it's likely they wouldn't care."
            - "Remember the coworker's life."
                "> You remind the host of the coworker's life: how they confided in them."
                "> The coworker trusted them. The host can trust them."
                "> The host resolves to better maintain their friendships. It... comforts them."
            - "Remember themselves."
                "> You remind the host that they have nothing to lose but everything to gain from confiding."
                "> The host resolves to better prioritize themselves. They are filled with determination."
    - "Your mother."
        - "> You remind the host that they ought to call their mother again."
        - "> Guilt pervades the host."
            - "Remind that that it's ok."
                "> The host feels a wave of calm wash over them. It was a mistake--nothing more."
                "> The host picks up the phone. A voice answers, and the host seems... happier."

#### Chapter 5
- Epilogue