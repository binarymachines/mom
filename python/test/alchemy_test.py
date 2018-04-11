import unittest

from media import alchemy, sql


class TestAlchemy(unittest.TestCase):
    def test_load_states(self):
        state_data = sql.run_query('select id, name, is_initial_state, is_terminal_state from state',
                                   schema='service')
        if len(state_data) == 0:
            raise Exception('invalid data for tests')

        for row in state_data:
            state_id = row[0]
            sqlstate = alchemy.retrieve_state_by_id(state_id)
            self.assertEquals(sqlstate.id, state_id)

    def test_load_modes(self):
        mode_data = sql.run_query('select name from mode', schema='service')
        if len(mode_data) == 0:
            raise Exception('invalid data for tests')

        for row in mode_data:
            mode_name = row[0]
            sqlmode = alchemy.retrieve_mode_by_name(mode_name)
            self.assertEquals(sqlmode.name, mode_name)

    def test_load_state_defaults(self):
        init_state_data = sql.run_query(
            "select id, name, is_initial_state, is_terminal_state from state where name = 'initial'",
            schema='service')

        if len(init_state_data) == 1:
            state_id = init_state_data[0][0]
            is_initial_state = init_state_data[0][1]
            sqlstate = alchemy.retrieve_state_by_id(state_id)
            self.assertEquals(sqlstate.is_initial_state, is_initial_state)

        else: raise Exception('invalid data for tests')

    def test_load_state_params(self):
        scan_mode_data = sql.run_query("select id, name from mode where name = 'scan'", schema='service')
        if len(scan_mode_data) == 1:
            sqlmode = alchemy.retrieve_mode_by_name(scan_mode_data[0][1])

            state_data = sql.run_query(
                "select status from mode_state_default where mode_id = '%s'" % (scan_mode_data[0][0]),
                schema='service')


            # state_param_data = sql.run_query(
            #     "select name, is_initial_state, is_terminal_state from state where name = 'initial'",
            #     schema='service')


            pass
        else: raise Exception('invalid data for tests')


if __name__ == '__main__':
    unittest.main()