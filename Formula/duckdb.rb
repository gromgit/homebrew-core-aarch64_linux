class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/cwida/duckdb/archive/v0.1.8.tar.gz"
  sha256 "18a984e80e14136f6a61f482387a6e159f5cafd256884e66cc21d6d7a511e33c"

  bottle do
    cellar :any
    sha256 "1a617e4f694bef51e44fae866f61f15fd7c3b22d86ed8781575c949a7963ab2e" => :catalina
    sha256 "360d21bfbd7860aa5f216ccf9dd985a18e40f6af8339f3bdbf4924cdc19fc1fa" => :mojave
    sha256 "b43327397c06199a6b79c2e6e6fc794b63e5a1372b15ccc10e1a9ec54590c540" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build

  def install
    mkdir "build/amalgamation"
    system Formula["python@3.8"].opt_bin/"python3", "scripts/amalgamation.py"
    cd "build/amalgamation" do
      system "cmake", "../..", *std_cmake_args, "-DAMALGAMATION_BUILD=ON"
      system "make"
      system "make", "install"
      bin.install "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS
    assert_equal "45.0", shell_output("#{bin}/duckdb_cli < #{path}").strip
  end
end
