class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.7.0.tar.gz"
  sha256 "62a7f20302dfcfddbd2c1d84a611ab7907f51540d8ce80894314627bd7b6cfe1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc738aace1687b55a881b0229f246a22eb14e9e47592b3d168851c6ba3f74ddb" => :big_sur
    sha256 "109b7e717ba4cec8d875f90a63bd9241a34585f34ada5bcc4dd5b39146af6e42" => :arm64_big_sur
    sha256 "2c4674501021cad781c3c2ce3fda60cfba7e2a00a2f6487af7080bedbef92d0d" => :catalina
    sha256 "c594947f6be3d9437ba1e236f49087eb51e7fdf63e32c30ea9b0a3c3ffd10298" => :mojave
  end

  depends_on "go" => :build

  def install
    ["rqbench", "rqlite", "rqlited"].each do |cmd|
      system "go", "build", *std_go_args, "-o", bin/cmd, "./cmd/#{cmd}"
    end
  end

  test do
    port = free_port
    fork do
      exec bin/"rqlited", "-http-addr", "localhost:#{port}",
                          "-raft-addr", "localhost:#{free_port}",
                          testpath
    end
    sleep 5

    (testpath/"test.sql").write <<~EOS
      CREATE TABLE foo (id INTEGER NOT NULL PRIMARY KEY, name TEXT)
      .schema
      quit
    EOS
    output = shell_output("#{bin}/rqlite -p #{port} < test.sql")
    assert_match "foo", output

    output = shell_output("#{bin}/rqbench -a localhost:#{port} 'SELECT 1'")
    assert_match "Statements/sec", output
  end
end
