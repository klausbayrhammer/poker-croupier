
service Croupier
{
    void register_player(1:string host, 2:i16 port)
    void register_spectator(1:string host, 2:i16 port)

    void start_sit_and_go()
    void start_live_action_game()
}