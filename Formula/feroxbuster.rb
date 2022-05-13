class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/2.7.1.tar.gz"
  sha256 "4fc37897d98bb09bfe738067eb5889adff20e0caef70e4487d20f41ec920381b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc96edbbabdbc5591f0b9309fb719854b20b7ba27be599a3beae37f3bf3970d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ea606faf63ed34435fcbfc5b88d75b1c224b5c839b79dae88b155f0a7a79c56"
    sha256 cellar: :any_skip_relocation, monterey:       "9fde637bcd81e1dcadff135ee88ae533c59a4b9de724825aa25c965effc68dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe32d752fb102c07262e617d957930521da7fe6270e6fb581858e6750325b640"
    sha256 cellar: :any_skip_relocation, catalina:       "a4661d46feac3ea50ccf440c52fa020f885e2de638314c92dbb28c20312f9135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4194630086e06e01b69e28e20658c21746c4623868f9702b1d73aab35b38d9"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
