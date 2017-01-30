public class DeactivateUser {
    public void Userdeactivation()
    {
        List<User> LstUser = new list<User>{};
        for(User InactiveUser  :[select id from User where LastLoginDate<:System.now().addDays(-90)])
        {
            // Query all users whose last login was 90 before.
            InactiveUser.IsActive = false;
            LstUser.add(InactiveUser);
            
        }
            update LstUser;//Update Users.
    }
}