# Configuration for Rufus::Mnemo, used to generate japanese-like words given a
# random integer.

# Monkey patch the module for the ability to reproducibly randomize the SYL
# array with a seed value.
module Rufus
  module Mnemo
    def self.randomize_syl!(seed_number)
      SYL.shuffle!(random: Random.new(seed_number))
    end

    # For debugging:
    def self.get_syl
      return SYL
    end
  end
end

# Make sure to define the seed value in the environment variables!
Rufus::Mnemo.randomize_syl!(ENV.fetch('MNEMO_RAND_SEED', 1).to_i);
