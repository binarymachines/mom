import unittest

from mildred import alchemy, sql


class TestAlchemy(unittest.TestCase):
    def test_load_states(self):
        state_data = sql.run_query('select name, initial_state_flag, terminal_state_flag from state',
                                   schema='mildred_introspection')
        if len(state_data) == 0:
            raise Exception('invalid data for test')

        for row in state_data:
            state_name = row[0]
            sqlstate = alchemy.retrieve_state(state_name)
            self.assertEquals(sqlstate.name, state_name)

    def test_load_modes(self):
        mode_data = sql.run_query('select name from mode', schema='mildred_introspection')
        if len(mode_data) == 0:
            raise Exception('invalid data for test')

        for row in mode_data:
            mode_name = row[0]
            sqlmode = alchemy.retrieve_mode(mode_name)
            self.assertEquals(sqlmode.name, mode_name)

    #
    def test_load_state_defaults(self):
        init_state_data = sql.run_query(
            "select name, initial_state_flag, terminal_state_flag from state where name = 'initial'",
            schema='mildred_introspection')

        if len(init_state_data) == 1:
            sqlstate = alchemy.retrieve_state(init_state_data[0][0])
            self.assertEquals(sqlstate.is_initial_state, init_state_data[0][1])

        else: raise Exception('invalid data for test')

    def test_load_state_params(self):
        scan_mode_data = sql.run_query("select id, name from mode where name = 'scan'", schema='mildred_introspection')
        if len(scan_mode_data) == 1:
            sqlmode = alchemy.retrieve_mode(scan_mode_data[0][1])

            state_data = sql.run_query(
                "select status from mode_state_default where mode_id = '%s'" % (scan_mode_data[0][0]),
                schema='mildred_introspection')


            # state_param_data = sql.run_query(
            #     "select name, initial_state_flag, terminal_state_flag from state where name = 'initial'",
            #     schema='mildred_introspection')


            pass
        else: raise Exception('invalid data for test')


if __name__ == '__main__':
    unittest.main()