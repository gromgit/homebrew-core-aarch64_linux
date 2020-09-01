class ClojureLsp < Formula
  desc "Language Server (LSP) for Clojure"
  homepage "https://github.com/snoe/clojure-lsp"
  # Switch to use git tag/revision as needed by `lein-git-version`
  url "https://github.com/snoe/clojure-lsp.git",
    tag:      "release-20200828T065654",
    revision: "36ce0a417df06f6fe2f7c9848b570f88e7602e20"
  version "20200828T065654"
  license "MIT"
  head "https://github.com/snoe/clojure-lsp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5c9e1043b5c6a88f6f01fe3fa4d2a7691a25c6bb341718b6f1d7a4634070227" => :catalina
    sha256 "be48a9f437585ab9c12b217f635c688a3f95216ae3bdb12fbdd742d9a6cdac01" => :mojave
    sha256 "8bdbfb86e01a9081a774f9f96eda55a89cb7302c35d8bf16651f4e420d748d09" => :high_sierra
  end

  depends_on "leiningen" => :build
  # The Java Runtime version only recognizes class file versions up to 52.0
  depends_on java: "1.8"

  def install
    system "lein", "uberjar"
    jar = Dir["target/clojure-lsp-*-standalone.jar"][0]
    libexec.install jar
    bin.write_jar_script libexec/File.basename(jar), "clojure-lsp"
  end

  test do
    require "Open3"

    begin
      stdin, stdout, _, wait_thr = Open3.popen3("#{bin}/clojure-lsp")
      pid = wait_thr.pid
      stdin.write <<~EOF
        Content-Length: 58

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Length", stdout.gets("\n")
    ensure
      Process.kill "SIGKILL", pid
    end
  end
end
