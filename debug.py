__db_debug_is_on = True
__db_debug_level = 0  # level until, not include

def debug(debug_level=0, message="no message"):
    """ 0 is the lowest level of debug
    larger level means more debug messages
    """
    if __db_debug_is_on is True:
        assert isinstance(debug_level, int)
        assert (debug_level >= 0)
        #assert isinstance(message, str)
        if debug_level < __db_debug_level:
            print ' '*debug_level,message