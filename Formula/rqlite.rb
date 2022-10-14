class Rqlite < Formula
  desc "Lightweight, distributed relational database built on SQLite"
  homepage "http://www.rqlite.com/"
  url "https://github.com/rqlite/rqlite/archive/v7.7.1.tar.gz"
  sha256 "bf96bf336b2437d463693359dcd9f533dbc0609994ae9ece7d7fd6172deb9681"
  license "MIT"
  head "https://github.com/rqlite/rqlite.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3694564636bf176f7edd95ea2a9cbda5022d1a7b8c42bdc82188c70115ea5cde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afb895eab0e9fa85cd7610fc848a1c3eb7ce28a8f43efb9fcf6f14c611c56af6"
    sha256 cellar: :any_skip_relocation, monterey:       "167032cd4e6cae4db4e05a29185147e08db4aea4fd4771b9fb692d91e4d7ad2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "34601ed2a1ebf294230b4c8a0760694a80d46bfdb054a186b36da01fc8905d50"
    sha256 cellar: :any_skip_relocation, catalina:       "fb4d5daffa74b42f54cadc1add73d5958d25fc15e47872911a4a47b70deaadbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "514f79d1562de92cb68e4b08f0fba7334844b327a33bc7391a04eb45bc358a94"
  end

  depends_on "go" => :build

  def install
    %w[rqbench rqlite rqlited].each do |cmd|
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/cmd, "./cmd/#{cmd}"
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
