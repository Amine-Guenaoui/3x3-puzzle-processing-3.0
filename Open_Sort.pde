class Open_Sort implements Comparator<MapPosition>{
 
    @Override
    public int compare(MapPosition e1, MapPosition e2) {
        /*if(e1.getCost() > e2.getCost()){
            return 1;
        } else {
            return -1;
        }*/
        return e1.getCost() - e2.getCost();
    }
}
