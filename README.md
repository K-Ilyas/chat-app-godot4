## Chat ( Server ~ client ) 

A chat client server is a networked application that allows multiple users to communicate with each other in real time. In Godot, one way to implement a chat client server is to use the high-level multiplayer API and the remote procedure call (RPC) mechanism. RPCs are functions that can be called from one peer to another over the network, using annotations such as @rpc or @master. For a chat client server, we can use RPCs to send and receive messages between the clients and the server. The server can act as the authority that validates and broadcasts the messages, while the clients can display the messages on their user interface. To make the chat more interactive, we can also use RPCs to send information about the clients' status, such as their name, avatar, or typing activity.

## Clock and synchronization

Godot has a Time singleton that offers methods for working with time1. The ISO 8601 standard describes the numerical representation of date and time in order to avoid confusion.

### Definition 
---

UNIX time refers to the number of seconds elapsed since January 1, 1970. Note that systems, including Godot’s, offer an implementation that allows you to get the time with a higher precision than the second. Warning: as indicated in the documentation, the system time is subject to involuntary, but also voluntary, changes. The Time singleton offers two methods for making precise measurements: get_ticks_msecs and get_ticks_usecs, which give the time elapsed since the launch of the process, without it being possible to modify it. We will use them in parallel with get_unix_time_from_system. Also be careful to check the output types: the get_ticks methods return int, while get_unix_time_from_system returns a 64-bit float. To synchronize the clients with the server, we will simulate the Network Time Protocol to find the drift of the client clock.
![Screenshot 2024-01-18 010316](https://github.com/K-Ilyas/chat-app-godot4/assets/61426347/cd222774-cec1-4afa-b4ca-528f5fc83005)

---

### Algorithm 1: Cristian's Algorithm

**Data:** C is the client, S is the server  
**Result:** The *timestamp* at which C must set its clock to synchronize with S.

1. C sends a request to S at local time T0
2. S responds by giving the real time of the server Ts from its clock
3. C receives the response at local time T1. C sets its clock to Ts + (T1 - T0)/2

This algorithm can also give a first value of latency (RTT, round-time-trip) which is here T1 - T0.

By continuously sending packets, it is therefore possible to estimate the average latency time, assuming that the latency time going is equivalent to the latency time returning.

---

### Algorithm 2: SNTP Algorithm

**Data:** A list of integers L that will receive the latency values.  
**Result:** The estimated latency of the client in ms.

1. **while size(L)<10 do**
    - The client C sends a request to the server S, giving its *timestamp T1*
    - S receives and responds to the client by giving T
    - C receives the result containing *T1*
    - C retrieves the *current timestamp T2*
    - The latency l is l = (T2 – T1)/2 and it is added to L
2. **end**
3. nb m ← median(L)
4. Remove from L all values Li greater than 2m.
5. The estimated latency is average(L)

---

## Screenshots
### Connection interface
![connexion](https://github.com/K-Ilyas/chat-app-godot4/assets/61426347/517b5b76-4fbd-4932-b561-57ddfb62de62)
### Chat interface (main)
![chat](https://github.com/K-Ilyas/chat-app-godot4/assets/61426347/9a845f20-4819-47f0-91b6-0b080cbd9251)



