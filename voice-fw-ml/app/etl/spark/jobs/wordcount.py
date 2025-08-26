from pyspark.sql import SparkSession
import sys

def main(input_path, output_path):
    spark = SparkSession.builder.appName("WordCount").getOrCreate()

    # Read input file
    text_file = spark.read.text(input_path).rdd.map(lambda r: r[0])

    # Split into words, count, sort
    counts = (
        text_file.flatMap(lambda line: line.split(" "))
        .map(lambda word: (word, 1))
        .reduceByKey(lambda a, b: a + b)
        .sortBy(lambda x: -x[1])
    )

    # Save results as text
    counts.saveAsTextFile(output_path)

    spark.stop()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: wordcount.py <input> <output>")
        sys.exit(-1)

    main(sys.argv[1], sys.argv[2])
