class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v5.4.2.tar.gz"
  sha256 "9a78542b72883e6452029500d64e6234fc719aab4147e240476c3f7a4ce801a6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef6d87d517b96f0bd49eed83e52372cc1c96c57b1b9bf4c607cc489fc0af925d" => :catalina
    sha256 "515eee131820fd1e4b3a9e7f5ec54b0b3d8e764fb9e9d7f86bd348cc726945da" => :mojave
    sha256 "a5cdf690a35b5e1858285a4bf796d49367b3fc46dbecbd8cfa4cf1e9cc8bcb13" => :high_sierra
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
