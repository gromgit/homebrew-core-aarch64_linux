class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.2.1.tar.gz"
  sha256 "1a5796b3ee8fc38315684bc5a2c41c960615de4f56e9c687b9afb00fb613d6e2"
  license "MIT"
  head "https://github.com/semihalev/sdns.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sdns"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "532adad2a0a3791f0bea62e961a1442e3488ab9597452e3d7f91e682a03b5668"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"sdns", "-config", etc/"sdns.conf"]
    keep_alive true
    error_log_path var/"log/sdns.log"
    log_path var/"log/sdns.log"
    working_dir opt_prefix
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
