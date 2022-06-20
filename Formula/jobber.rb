class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz"
  sha256 "fd88a217a413c5218316664fab5510ace941f4fdb68dcb5428385ff09c68dcc2"
  license "MIT"
  head "https://github.com/dshearer/jobber.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jobber"
    sha256 aarch64_linux: "b4e7ba34255360d2024df06e31570a47c0c9e93f024ac7075f71d14eeed0eba3"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--libexecdir=#{libexec}", "--sysconfdir=#{etc}",
      "--localstatedir=#{var}"
    system "make", "install"
  end

  plist_options startup: true
  service do
    run libexec/"jobbermaster"
    keep_alive true
    log_path var/"log/jobber.log"
    error_log_path var/"log/jobber.log"
  end

  test do
    (testpath/".jobber").write <<~EOS
      version: 1.4
      jobs:
        Test:
          cmd: 'echo "Hi!" > "#{testpath}/output"'
          time: '*'
    EOS

    fork do
      exec libexec/"jobberrunner", "#{testpath}/.jobber"
    end
    sleep 3

    assert_match "Hi!", (testpath/"output").read
  end
end
