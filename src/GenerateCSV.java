import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class GenerateCSV {

	public static void main(String[] args) {
		int showingCount = 1;
		int ticketID = 1;
		int ticketprice = 10;
		int onlineTransactionCount = 0;
		int salesTransactionCount = 1;
		int promotionCount = 0;
		int noOfCustomers = 1000;
		int noOfCinemas = 100;
		//Date format
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		Calendar endDate =Calendar.getInstance();
		//End date
		endDate.set(2013, 11, 31, 23, 0);
		Calendar morningDate =Calendar.getInstance();
		//Start Date
		morningDate.set(2004, 0, 1, 5, 0);
		//Show times
		String [] times = new String[]{"05:00:00","14:00:00","22:00:00"};
		//Possible Hall Rows -  each row has 10 seats. Increase with hall size
		String [] rows = new String[]{"A","B","C","D","E","F"};
		//Possible promotions
		String [] promotions = new String[]{"Free Popcorn", "Free Ice Cream", "Limited Edition Mug", "Lucky Draw"};
		//Possible Hall Sizes
		int [] hallSizes = new int[]{10,20,30};
		int[] cinemaHallSizes = createHalls(noOfCinemas,hallSizes);
		
		
		File showingsF = new File("Showing.txt");
		File salesTransactionF = new File("SalesTransaction.txt"); 
		File onlineTransactionF = new File("OnlineTransaction.txt"); 
		File ticketF = new File("Ticket.txt"); 
		File promotionF = new File("Promotion.txt"); 
		File salesFTF = new File("SalesFT.txt"); 
		// if file doesnt exists, then create it
		if (!showingsF.exists()) {
			try {
				showingsF.createNewFile();
				salesTransactionF.createNewFile();
				onlineTransactionF.createNewFile();
				ticketF.createNewFile();
				salesFTF.createNewFile();
				
				FileWriter showingsFfw = new FileWriter(showingsF.getAbsoluteFile());
				BufferedWriter showingsFbw = new BufferedWriter(showingsFfw);
				FileWriter promotionFfw = new FileWriter(promotionF.getAbsoluteFile());
				BufferedWriter promotionFbw = new BufferedWriter(promotionFfw);
				FileWriter salesTransactionFfw = new FileWriter(salesTransactionF.getAbsoluteFile());
				BufferedWriter salesTransactionFbw = new BufferedWriter(salesTransactionFfw);
				FileWriter onlineTransactionFfw = new FileWriter(onlineTransactionF.getAbsoluteFile());
				BufferedWriter onlineTransactionFbw = new BufferedWriter(onlineTransactionFfw);
				FileWriter ticketFfw = new FileWriter(ticketF.getAbsoluteFile());
				BufferedWriter ticketFbw = new BufferedWriter(ticketFfw);
				FileWriter salesFTFfw = new FileWriter(salesFTF.getAbsoluteFile());
				BufferedWriter salesFTFbw = new BufferedWriter(salesFTFfw);
				salesFTFbw.append("SalesTransactionID,CustomerID,MovieID,CinemaID,ShowingID,HallID,TicketID,PromotionID,OnlineTransactionID\n");
				
				
				while(morningDate.before(endDate)){
					//30% chance of having a promotion every day
					boolean promotionActive = ((int)(Math.random()+0.7))==0?true:false;
					String promoDesc = promotionActive?promotions[(int)(Math.random()*promotions.length)]:"";
					if(promotionActive)
						promotionFbw.append(++promotionCount + "," + promoDesc + ",0," + format.format(morningDate.getTime()) + "," + format.format(morningDate.getTime())+"\n");
					//each cinema has fixed number of showings
					for(String time:times){
						for(int i =1;i<=noOfCinemas;i++){
							//30% chance for each cinema to carry the promotion if it occurs that day
							boolean promotionInCinema = promotionActive?(((int)(Math.random()+0.7))==0)?true:false:false;
							//System.out.println("INSERT INTO Showing (ShowingID,ShowingDate,ShowingTime) VALUES (" + showingCount + ",'" + format.format(morningDate.getTime()) + "','" + time +"');\n");
							showingsFbw.append(showingCount + "," + format.format(morningDate.getTime()) + "," + time +"\n");
							//add transactions
							int totalTicketsSold = 0;
							//There are 100 movies, randomly show one
							int movieID = (int)(100*Math.random())+1;
							//Number of seats filled per cinema per showing is random
							int numSeatFilled = (int)(cinemaHallSizes[i-1]*Math.random());
							while(totalTicketsSold < numSeatFilled){
								int customerId = (int)(noOfCustomers*Math.random())+1;
								//
								if(numSeatFilled- totalTicketsSold < 6){
									salesTransactionFbw.append(salesTransactionCount + ","+(numSeatFilled- totalTicketsSold)*10+","+format.format(morningDate.getTime())+","+time+"\n");
									String onlineTransactionIDString = ((int)(Math.random()+0.5))==0?"NULL":onlineTransaction();
									boolean onlineTransaction = false;
									if(!onlineTransactionIDString.contentEquals("NULL")){
										onlineTransaction=true;
										onlineTransactionFbw.append(++onlineTransactionCount +"," + onlineTransactionIDString + "\n");
									}
									for(int tc = totalTicketsSold; tc <numSeatFilled ;tc++){
										ticketFbw.append(ticketID+","+ rows[tc/10] +","+ ((tc%10)+1) +","+ticketprice+"\n");
										salesFTFbw.append(salesTransactionCount+","+customerId+"," + movieID + "," + i + "," + showingCount + "," + i + "," +ticketID +","+ (promotionInCinema?promotionCount:"")+","+ (onlineTransaction?onlineTransactionCount:"")+"\n");
										ticketID++;
									}
									totalTicketsSold+=(numSeatFilled- totalTicketsSold);
									salesTransactionCount++;
								}else{
									//1-5 tickets in a transaction
									int ticketsInTransaction = (int)(5 *Math.random()) +1;
									salesTransactionFbw.append(salesTransactionCount + ","+(numSeatFilled- totalTicketsSold)*10+","+format.format(morningDate.getTime())+","+time+"\n");
									//50% chance of transaction being online transaction
									String onlineTransactionIDString = ((int)(Math.random()+0.5))==0?"NULL":onlineTransaction();
									boolean onlineTransaction = false;
									if(!onlineTransactionIDString.contentEquals("NULL")){
										onlineTransaction=true;
										onlineTransactionFbw.append(++onlineTransactionCount +"," + onlineTransactionIDString + "\n");
									}
									for(int tc = totalTicketsSold; tc <totalTicketsSold+ticketsInTransaction ;tc++){
										ticketFbw.append(ticketID+","+ rows[tc/10] +","+ ((tc%10)+1) +","+ticketprice+"\n");
										salesFTFbw.append(salesTransactionCount+","+customerId+"," + movieID + "," + i + "," + showingCount + "," + i + "," +ticketID +","+ (promotionInCinema?promotionCount:"")+","+ (onlineTransaction?onlineTransactionCount:"")+"\n");
										ticketID++;
									}
									totalTicketsSold+=ticketsInTransaction;
									salesTransactionCount++;
								}
							}
							showingCount++;
						}
					}
					//increment the date by 1
					morningDate.add(Calendar.DATE, 1);
				}
				showingsFbw.close();
				salesTransactionFbw.close();
				onlineTransactionFbw.close();
				ticketFbw.close();
				salesFTFbw.close();
				promotionFbw.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		
		
	}
	//generates a random online transaction pair
	public static String onlineTransaction(){
		String [] systems = new String[]{"Windows XP","Windows 7","Windows 8", "Mac OSX"};
		String [] browsers = new String[]{"Safari","Firefox","Internet Explorer","Chrome","Opera","Midori"};
		return systems[(int)(systems.length*Math.random())] + "," + browsers[(int)(browsers.length*Math.random())];
	}
	
	public static int[] createHalls(int noOfCinemas, int[]hallSizes){
		File file = new File("Hall.txt");
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
							bw.append(i + "," + size +"\n");
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
