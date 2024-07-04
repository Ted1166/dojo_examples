use starknet::ContractAddress;

#[derive(Component, Copy, Drop, Serde, Serdelen)]
// Game component
struct Game {
    #[key]
    game_id: u32,
    // tells us the current id of the game.
    start_time: u64,
    // stores the time when the game started.
    turns_remaining: usize, 
    // the time limit for the player to escape.
    is_finished: bool,
    // if the player finished the game or not.
    creator: ContractAddress
    // the player address which created the game 
}

#[derive(Component, Copy, Drop, Serde, Serdelen)]
struct Object {
    #[key]
    game_id: u32,
    #[key]
    player_id: ContractAddress,
    #[key]
    object_id: felt252,
    description: felt252
}

#[derive(Component, Copy, Drop, Serde, Serdelen)]
struct Door {
    #[key]
    game_id: u32,
    #[key]
    player_id: ContractAddress,
    secret: felt252
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline(always)]
    fn tick(self: Game) -> bool {
        let info = starknet::get_block_info().unbox();

        if info.block_timestamp < self.start_time {
            return false;
        }

        if self.is_finished {
            return false;
        }
        true
    }
}