public class ParkLocator {

    public static String[] country(String objective){
         ParkService.ParksImplPort Locator = new ParkService.ParksImplPort();
        return Locator.byCountry(objective);
    }
}