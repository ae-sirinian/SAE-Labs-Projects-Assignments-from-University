#include <stdio.h>
#include "node.h"

int connectcosts[NUMNODES][NUMNODES];

/* Setup the network costs */
void initcosts() {
	static int initialized = 0;
	if (!initialized) {
		/* initialize by hand since not all compilers allow array initilization */
		connectcosts[0][1] = connectcosts[1][0] = 1; // x0
		connectcosts[1][2] = connectcosts[2][1] = 1; // x1
		connectcosts[2][3] = connectcosts[3][2] = 2; // x2
		connectcosts[0][3] = connectcosts[3][0] = 6; // x3
		connectcosts[1][4] = connectcosts[4][1] = 5; // x4
		connectcosts[0][2] = connectcosts[2][0] = 4; // x5
		connectcosts[3][4] = connectcosts[4][3] = 1; // x6

		/* Not connected nodes */
		connectcosts[0][4] = connectcosts[4][0] = connectcosts[1][3] =
			connectcosts[3][1] = connectcosts[2][4] = connectcosts[4][2] =
			999;

		/* Loopback links */
		connectcosts[0][0] = connectcosts[1][1] = connectcosts[2][2] =
			connectcosts[3][3] = connectcosts[4][4] = 0;
	}
}

/**
 * H synarthsh ayth pairnei san orisma enan deikth se Node. To pedio
 * id ths domhs prepei na einai arxikopoihmeno sto index toy komboy (p.x.
 * 0 gia to node 0, 1 gia to node 1, kok) H synarthsh ayth prepei na
 * arxikopoihsei to routing table toy komboy me bash ton pinaka connectcosts
 * poy orizetai kai arxikopoieitai sto node.c kai katopin na steilei ena
 * katallhlo RtPkt se oloys toys geitonikoys komboys toy node.
 */
void initRT(Node* n) {
	int i;
	int j;
	/*
	printf("initializing node %d \n", n->id);
	*/	
	for(i=0; i<NUMNODES; i++){
		n->rt.cost[i] = connectcosts[n->id][i];
		
		if(n->rt.cost[i] == 999){
			continue;
		}else{
			n->rt.nexthop[i] = i;
		}
	}
	/*
	for(i=0; i<NUMNODES; i++){
		printf("%d	%d	%d \n", i, n->rt.nexthop[i], n->rt.cost[i]);
	}
	*/

	/*
	printf("initializing node's %d packet \n", n->id);
	*/
	for(i=0; i<NUMNODES; i++){
		if(i != (n->id) && n->rt.cost[i] != 999){
			RtPkt packet;
			packet.sourceid = n->id;
			packet.destid = i;
			
			for(j=0; j<NUMNODES; j++){
				packet.mincost[j] = n->rt.cost[j];
			}
			
			/**
			printf("packet.sourceid = %d, packet.destid = %d \n", packet.sourceid, packet.destid);
			for(j=0; j<NUMNODES; j++){
				printf("%d	%d \n", j, packet.mincost[j]);
			}
			**/

			tolayer2(packet);
		}
	}
}

/**
 * H synarthsh ayth pairnei san orisma enan deikth se Node kai enan
 * deikth se RtPkt. Prepei na ananewsei to routing table toy Node me
 * bash ta periexomena toy RtPkt kai, an ypar3oyn allages, na steilei ena
 * katallhlo RtPkt se oloys toys geitonikoys komboys toy node.
 */
void updateRT(Node* n, RtPkt* rcvdpkt) {
	int i;
	static int j = 0;
	for(i=0; i<NUMNODES; i++){
		if( ( (rcvdpkt->mincost[i]) + (n->rt.cost[rcvdpkt->sourceid]) ) < (n->rt.cost[i]) ){
			(n->rt.cost[i]) = (n->rt.cost[rcvdpkt->sourceid]) + (rcvdpkt->mincost[i]);
			(n->rt.nexthop[i]) = (n->rt.nexthop[rcvdpkt->sourceid]);
		}
	}
}

/**
 * H synarthsh ayth pairnei san orisma enan deikth se Node. Prepei na
 * typwsei sto standard output to routing table toy node: apostaseis/costs
 * pros toys alloys komboys kai to epomeno bhma/nexthop gia th dromologhsh
 * paketwn pros aytoys.
 */
void printRT(Node* n) {
	int i;
	printf("	node %d	\n", n->id);
	printf("	D	NH	C	\n");
	for(i=0; i<NUMNODES; i++){
		printf("	%d	%d	%d	\n", i, n->rt.nexthop[i], n->rt.cost[i]);
	}
}

