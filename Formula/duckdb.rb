class Duckdb < Formula
  desc "Embeddable SQL OLAP Database Management System"
  homepage "https://www.duckdb.org"
  url "https://github.com/duckdb/duckdb.git",
      tag:      "v0.3.3",
      revision: "fe9ba80039e4a0f20eb8d7fb7d6d9a4984156cbd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5220a276616fd03ede5c290fa19e50d2cf04278ade22d1e1a47fca9edee92403"
    sha256 cellar: :any,                 arm64_big_sur:  "0699a9c4eb3ae0a6ad6db51076616c160894ed7399b6ba0f1ae8b1ac171838a5"
    sha256 cellar: :any,                 monterey:       "8669e3cce9ae6a37799304fb5cb78f64199427282456d84d0571e64f4d1a85d9"
    sha256 cellar: :any,                 big_sur:        "eca95bce4b184f4e70de7cc5183bfa576bb13028daa30945c874b2aca21e5526"
    sha256 cellar: :any,                 catalina:       "7cca3bf07cbb77cfd30a69c4a0c8458db9e5e901040e0b9d7f69c0cbc7b15842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90b225cdb4843809af6d7960729122a0aedb6309f91be7ab0b8a115716f37c2b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  def install
    ENV.deparallelize if OS.linux? # amalgamation builds take GBs of RAM
    mkdir "build/amalgamation"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/amalgamation.py", "--extended"
    system Formula["python@3.10"].opt_bin/"python3", "scripts/parquet_amalgamation.py"
    cd "src/amalgamation" do
      system "cmake", "../..", *std_cmake_args
      system "make"
      system "make", "install"
      bin.install "duckdb"
      # The cli tool was renamed (0.1.8 -> 0.1.9)
      # Create a symlink to not break compatibility
      bin.install_symlink bin/"duckdb" => "duckdb_cli"
    end
  end

  test do
    path = testpath/"weather.sql"
    path.write <<~EOS
      CREATE TABLE weather (temp INTEGER);
      INSERT INTO weather (temp) VALUES (40), (45), (50);
      SELECT AVG(temp) FROM weather;
    EOS

    expected_output = <<~EOS
      ┌─────────────┐
      │ avg("temp") │
      ├─────────────┤
      │ 45.0        │
      └─────────────┘
    EOS

    assert_equal expected_output, shell_output("#{bin}/duckdb_cli < #{path}")
  end
end
