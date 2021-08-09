import psycopg2 as pg
import datetime
from collections import defaultdict


# Class to represent a graph
class Graph:
    def __init__(self, vertices):
        self.graph = defaultdict(list)  # dictionary containing adjacency List
        self.V = vertices  # No. of vertices

    # function to add an edge to graph
    def addEdge(self, u, v):
        self.graph[u].append(v)

    # A recursive function used by topologicalSort
    def topologicalSortUtil(self, v, visited, stack):

        # Mark the current node as visited.
        visited[v] = True

        # Recur for all the vertices adjacent to this vertex
        for i in self.graph[v]:
            if not visited[i]:
                self.topologicalSortUtil(i, visited, stack)

            # Push current vertex to stack which stores result
        stack.insert(0, v)

    # The function to do Topological Sort. It uses recursive
    # topologicalSortUtil()
    def topologicalSort(self):
        # Mark all the vertices as not visited
        visited = [False] * self.V
        stack = []

        # Call the recursive helper function to store Topological
        # Sort starting from all vertices one by one
        for i in range(self.V):
            if visited[i] == False:
                self.topologicalSortUtil(i, visited, stack)

            # Print contents of the stack
        return (stack)  # import psycopg2


# connect to databases
src_conn = pg.connect(
    "host=127.0.0.1 dbname=src user=postgres password=7230155")
dst_conn = pg.connect(
    "host=127.0.0.1 dbname=dst user=postgres password=7230155")
src_cur = src_conn.cursor()
dst_cur = dst_conn.cursor()
# execute table name
src_cur.execute("""
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;""")
# sort tables
tables_list = src_cur.fetchall()
tables_list.sort()
#execute foreign key
src_cur.execute("""SELECT
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name 
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
      AND ccu.table_schema = tc.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY';""")

fk_list = src_cur.fetchall()


# Python program to print topological sorting of a DAG
g = Graph(tables_list.size())
for fk in fk_list:
    g.addEdge(tables_list(fk[2].index()), tables_list(fk[0].index()))

sorted_index = g.topologicalSort()
sorted_tables = []
for x in sorted_index:
    sorted_tables.append(tables_list.get(x))

# get source database tables and their primery keys
src_cur.execute("""
    select kcu.table_name,`
           string_agg(kcu.column_name,', ') as key_columns
    from information_schema.table_constraints tco
    join information_schema.key_column_usage kcu 
         on kcu.constraint_name = tco.constraint_name
         and kcu.constraint_schema = tco.constraint_schema
         and kcu.constraint_name = tco.constraint_name
    where tco.constraint_type = 'PRIMARY KEY' and kcu.column_name not like '%at'
    group by tco.constraint_name,
           kcu.table_schema,
           kcu.table_name
    order by kcu.table_schema,
             kcu.table_name;""")

src_tables = src_cur.fetchall()
keys = []
tables = []
# to have the key and tables in sorted order(this come from the topological sort)
for Y in sorted_tables:
    for x in src_tables:
        if Y == x[0]:
            tables.append(x)
            keys.append(x[0])


# refactor result of querry
def refactor(result):
    for y in result:
        if isinstance(y, datetime.date):
            i = result.index(y)
            result = list(result)
            result[i] = '%s' % (str(y))
            result = tuple(result)
        if y is None:
            i = result.index(y)
            result = list(result)
            result[i] = NULL
            result = tuple(result)

    return result


for table in sorted_tables:
    # insert new records
    table_name = table[0]
    primary_key = table[1]
    if table_name[-7:] != "updated":
        dst_cur.execute("SELECT MAX(transfered_at) FROM %s" % table_name)
        last_update = dst_cur.fetchone()
        last_update = str(last_update[0])
        if last_update == 'None':
            src_cur.execute("SELECT * FROM %s " % table_name)
            src_query = src_cur.fetchall()
        else:
            src_cur.execute("SELECT * FROM %s WHERE created_at > '%s' " % (table_name, last_update))
            src_query = src_cur.fetchall()

        for row in src_query:
            row = refactor(row)
            dst_cur.execute("INSERT INTO %s VALUES %s;" % (table_name, row))
            dst_conn.commit()
    # یک راه دیگه هم برای پیاده سازی اینزرت وجود داره که دیگه نیازی به استفاده از ستون create_at نداریم
    #   for table in sorted_tables.inverse():
    #     table_name = table[0]
    #     primary_key = table[1]
    #     if table_name[-7:] != "updated":
    #         src_cur.execute("SELECT %s FROM %s" % (primary_key, table_name))
    #         src_query = src_cur.fetchall()
    #         dst_cur.execute("SELECT %s FROM %s" % (primary_key, table_name))
    #         dst_query = dst_cur.fetchall()
    #
    #         for record in src_query:
    #             if record not in dist_query:
    #                 src_cur.execute("SELECT * FROM %s WHERE %s = %s " % (table_name, primary_key, str(record)))
    #                 src_query = src_cur.fetchone()
    #                 dst_cur.execute("INSERT INTO %s VALUES %s;" % (table_name, src_query))
    #                 dst_conn.commit()

    # update old records
    if table_name[-7:] == "updated":
        src_cur.execute("""
        select  kcu.ordinal_position as position
        from information_schema.table_constraints tco
        join information_schema.key_column_usage kcu 
             on kcu.constraint_name = tco.constraint_name
             and kcu.constraint_schema = tco.constraint_schema
             and kcu.constraint_name = tco.constraint_name
        where tco.constraint_type = 'PRIMARY KEY' and kcu.table_name = %s ;""", table_name[:-8])
        col_no_query = src_cur.fetchall()
        col_no = col_no_query.value()-1
        src_cur.execute("SELECT * FROM %s" % table_name)
        src_query = src_cur.fetchall()

        updated = []
        for record in src_query:
            record = refactor(record)
            if not record[col_no] in updated:
                dst_cur.execute("DELETE FROM %s WHERE %s = %s ;" % (table_name[:-8], primary_key, record[col_no]))
                #delete the record from deleted table because it go there because of trigger
                dst_cur.execute("DELETE FROM %s WHERE %s = %s ;" % (table_name[:-8]+"_deleted", primary_key, record[col_no]))
		src_cur.execute("SELECT * FROM %s WHERE %s = %s " % (table_name[:-8], primary_key, record[col_no]))
                query = src_cur.fetchall()
                query = refactor(query)

                dst_cur.execute("INSERT INTO %s VALUES %s;" % (table_name[:-8], query))
                updated.append(record[col_no])

            dst_cur.execute("INSERT INTO %s VALUES %s;" % (table_name, record))
            dst_conn.commit()

        # delete all row from src db
        src_cur.execute("DELETE FROM %s;" % table_name)
        src_conn.commit()

# delete records
for table in sorted_tables.inverse():
    table_name = table[0]
    primary_key = table[1]
    if table_name[-7:] != "updated":
        src_cur.execute("SELECT %s FROM %s" % (primary_key, table_name))
        src_query = src_cur.fetchall()
        dst_cur.execute("SELECT %s FROM %s" % (primary_key, table_name))
        dst_query = dst_cur.fetchall()

        for record in dst_query:
            if record not in src_query:
                dst_cur.execute("DELETE FROM %s WHERE %s = %s ;" % (table_name, primary_key, record))
                dst_conn.commit()

# close connections
dst_conn.close()
src_conn.close()
