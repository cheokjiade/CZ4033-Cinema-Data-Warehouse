import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class MainOLD {

	public static void main(String[] args) {
		int showingCount = 1;
		int ticketID = 1;
		int ticketprice = 10;
		int onlineTransactionCount = 0;
		int salesTransactionCount = 1;
		int noOfCustomers = 1000;
		int noOfCinemas = 100;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar endDate =Calendar.getInstance();
		endDate.set(2013, 11, 31, 23, 0);
		Calendar morningDate =Calendar.getInstance();
		morningDate.set(2004, 0, 1, 5, 0);
		String [] times = new String[]{"05:00:00","14:00:00","22:00:00"};
		String [] rows = new String[]{"A","B","C","D","E","F"};
		
		
		int [] hallSizes = new int[]{10,20,30};
		int[] cinemaHallSizes = createHalls(noOfCinemas,hallSizes);
		
		
		File file = new File("showings.sql");
		File salesTransaction = new File("salestransaction.txt"); 
		// if file doesnt exists, then create it
		if (!file.exists()) {
			try {
				file.createNewFile();
				FileWriter fw = new FileWriter(file.getAbsoluteFile());
				BufferedWriter bw = new BufferedWriter(fw);
				while(morningDate.before(endDate)){
					for(String time:times){
						for(int i =1;i<=noOfCinemas;i++){
							//System.out.println("INSERT INTO Showing (ShowingID,ShowingDate,ShowingTime) VALUES (" + showingCount + ",'" + format.format(morningDate.getTime()) + "','" + time +"');\n");
							bw.append("INSERT INTO Showing (ShowingID,ShowingDate,ShowingTime) VALUES (" + showingCount + ",'" + format.format(morningDate.getTime()) + "','" + time +"');\n");
							//add transactions
							int totalTicketsSold = 0;
							int movieID = (int)(100*Math.random())+1;
							int numSeatFilled = (int)(cinemaHallSizes[i-1]*Math.random());
							while(totalTicketsSold < numSeatFilled){
								int customerId = (int)(1000*Math.random())+1;
								if(numSeatFilled- totalTicketsSold < 6){
									bw.append("INSERT INTO SalesTransaction (SalesTransactionID,SalesTransactionTotalPrice,SalesTransactionDate,SalesTransactionTime) VALUES (" + salesTransactionCount + ",'"+(numSeatFilled- totalTicketsSold)*10+"','"+format.format(morningDate.getTime())+"','"+time+"');\n");
									String onlineTransactionIDString = ((int)(Math.random()+0.5))==0?"NULL":onlineTransaction();
									boolean onlineTransaction = false;
									if(!onlineTransactionIDString.contentEquals("NULL")){
										onlineTransaction=true;
										bw.append("INSERT INTO OnlineTransaction (OnlineTransactionID,System,Browser) VALUES ("+ ++onlineTransactionCount +"," + onlineTransactionIDString + ");\n");
									}
									for(int tc = totalTicketsSold; tc <numSeatFilled ;tc++){
										bw.append("INSERT INTO Ticket (TicketID,Row,Seat,TicketPrice) VALUES ("+ticketID+",'"+ cinemaHallSizes[totalTicketsSold%100] +"','"+ (tc%100)+1 +"','"+ticketprice+"');\n");
										bw.append("INSERT INTO SalesFT (SalesTransactionID,CustomerID,MovieID,CinemaID,ShowingID,HallID,TicketID,PromotionID,OnlineTransactionID) VALUES ("+salesTransactionCount+","+customerId+"," + movieID + "," + i + "," + showingCount + "," + i + "," +ticketID +","+"NULL"+","+ (onlineTransaction?onlineTransactionCount:"NULL")+");\n");
										ticketID++;
									}
									totalTicketsSold+=(numSeatFilled- totalTicketsSold);
									salesTransactionCount++;
								}else{
									int ticketsInTransaction = (int)(5 *Math.random()) +1;
									bw.append("INSERT INTO SalesTransaction (SalesTransactionID,SalesTransactionTotalPrice,SalesTransactionDate,SalesTransactionTime) VALUES (" + salesTransactionCount + ",'"+(numSeatFilled- totalTicketsSold)*10+"','"+format.format(morningDate.getTime())+"','"+time+"');\n");
									String onlineTransactionIDString = ((int)(Math.random()+0.5))==0?"NULL":onlineTransaction();
									boolean onlineTransaction = false;
									if(!onlineTransactionIDString.contentEquals("NULL")){
										onlineTransaction=true;
										bw.append("INSERT INTO OnlineTransaction (OnlineTransactionID,System,Browser) VALUES ("+ ++onlineTransactionCount +"," + onlineTransactionIDString + ");\n");
									}
									for(int tc = totalTicketsSold; tc <totalTicketsSold+ticketsInTransaction ;tc++){
										bw.append("INSERT INTO Ticket (TicketID,Row,Seat,TicketPrice) VALUES ("+ticketID+",'"+ cinemaHallSizes[totalTicketsSold%100] +"','"+ (tc%100)+1 +"','"+ticketprice+"');\n");
										bw.append("INSERT INTO SalesFT (SalesTransactionID,CustomerID,MovieID,CinemaID,ShowingID,HallID,TicketID,PromotionID,OnlineTransactionID) VALUES ("+salesTransactionCount+","+customerId+"," + movieID + "," + i + "," + showingCount + "," + i + "," +ticketID +","+"NULL"+","+ (onlineTransaction?onlineTransactionCount:"NULL")+");\n");
										ticketID++;
									}
									totalTicketsSold+=ticketsInTransaction;
									salesTransactionCount++;
								}
							}
							showingCount++;
						}
					}
					morningDate.add(Calendar.DATE, 16);
				}
				bw.close();
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		
		
	}
	public static String onlineTransaction(){
		String [] systems = new String[]{"Windows XP","Windows 7","Windows 8", "Mac OSX"};
		String [] browsers = new String[]{"Safari","Firefox","Internet Explorer","Chrome"};
		return "'"+systems[(int)(systems.length*Math.random())] + "','" + browsers[(int)(browsers.length*Math.random())]+"'";
	}
	
	public static int[] createHalls(int noOfCinemas, int[]hallSizes){
		File file = new File("halls.sql");
		int[]cinemaSizes = new int[100];
		// if file doesnt exists, then create it
		if (!file.exists()) {
			try {
				file.createNewFile();
				FileWriter fw = new FileWriter(file.getAbsoluteFile());
				BufferedWriter bw = new BufferedWriter(fw);
						for(int i =1;i<=noOfCinemas;i++){
							//System.out.println("INSERT INTO Showing (ShowingID,ShowingDate,ShowingTime) VALUES (" + showingCount + ",'" + format.format(morningDate.getTime()) + "','" + time +"');\n");
							int size =hallSizes[(int)(Math.random()*3)];
							bw.append("INSERT INTO Hall (HallID,HallSize) VALUES (" + i + ",'" + size +"');\n");
							cinemaSizes[i-1] = size;
						}

				bw.close();
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return cinemaSizes;
	}

}
