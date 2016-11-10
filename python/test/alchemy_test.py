import unittest

from mildred import alchemy, sql


class TestAlchemy(unittest.TestCase):
    def setUp(self):
        self.state_data = sql.run_query('select name, initial_state_flag, terminal_state_flag from state', schema='mildred_introspection')
        self.mode_data = sql.run_query('select name from mode', schema='mildred_introspection')
        self.init_state = sql.run_query("select name, initial_state_flag, terminal_state_flag from state where name = 'initial'", schema='mildred_introspection')

    def test_load_states(self):
        for row in self.state_data:
            state_name = row[0]
            sqlstate = alchemy.retrieve_state(state_name)
            self.assertEquals(sqlstate.name, state_name)

    def test_load_modes(self):
        for row in self.mode_data:
            mode_name = row[0]
            sqlmode = alchemy.retrieve_mode(mode_name)
            self.assertEquals(sqlmode.name, mode_name)

    #
    # def test_load_state_defaults(self):
    #
    #         sqlstate = alchemy.retrieve_state(self.scan_state.name)
    #         pass
    #         # self.assertEquals(sqlstate.name, state_name)


if __name__ == '__main__':
    unittest.main()