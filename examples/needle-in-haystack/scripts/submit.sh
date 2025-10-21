set -x

# TODO: implement this example

EXAMPLE_DIR=/user/hadoop/needle-in-haystack

# input dir must exist, output dir must not exist
hadoop fs -mkdir -p $EXAMPLE_DIR/input
hadoop fs -rm -r -f $EXAMPLE_DIR/output

# upload the input data
hadoop fs -copyFromLocal ./resources/haystack-* $EXAMPLE_DIR/input

# minimal wordcount example with hadoop streaming and python3
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -files ./mapper.py,./reducer.py,./resources/needle.txt \
  -input $EXAMPLE_DIR/input \
  -output $EXAMPLE_DIR/output \
  -mapper "mapper.py" \
  -reducer "reducer.py"

# check the output
hadoop fs -cat $EXAMPLE_DIR/output/part-*
