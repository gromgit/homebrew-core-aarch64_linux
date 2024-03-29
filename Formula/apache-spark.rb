class ApacheSpark < Formula
  desc "Engine for large-scale data processing"
  homepage "https://spark.apache.org/"
  url "https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz"
  mirror "https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz"
  version "3.3.0"
  sha256 "306b550f42ce1b06772d6084c545ef8448414f2bf451e0b1175405488f2a322f"
  license "Apache-2.0"
  head "https://github.com/apache/spark.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/apache-spark"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "db8c95913d1bcbe16812fbead0e6a4afb75dc17b1c593a71522665f757d4e6a3"
  end


  depends_on "openjdk"

  def install
    # Rename beeline to distinguish it from hive's beeline
    mv "bin/beeline", "bin/spark-beeline"

    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  test do
    assert_match "Long = 1000",
      pipe_output(bin/"spark-shell --conf spark.driver.bindAddress=127.0.0.1",
                  "sc.parallelize(1 to 1000).count()")
  end
end
