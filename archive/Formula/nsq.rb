class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/v1.2.1.tar.gz"
  sha256 "5fd252be4e9bf5bc0962e5b67ef5ec840895e73b1748fd0c1610fa4950cb9ee1"
  license "MIT"
  head "https://github.com/nsqio/nsq.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nsq"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "eccb1e1e59b89890751c5d775d9bf34ce619e63a6ec3f72bc174dcd63acca36b"
  end

  depends_on "go" => :build

  def install
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
    prefix.install_metafiles
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  service do
    run [bin/"nsqd", "-data-path=#{var}/nsq"]
    keep_alive true
    working_dir var/"nsq"
    log_path var/"log/nsqd.log"
    error_log_path var/"log/nsqd.error.log"
  end

  test do
    lookupd = fork do
      exec bin/"nsqlookupd"
    end
    sleep 2
    d = fork do
      exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
    end
    sleep 2
    admin = fork do
      exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
    end
    sleep 2
    to_file = fork do
      exec bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                              "--output-dir=#{testpath}",
                              "--topic=test"
    end
    sleep 2
    system "curl", "-d", "hello", "http://127.0.0.1:4151/pub?topic=test"
    sleep 2
    dat = File.read(Dir["*.dat"].first)
    assert_match "test", dat
    assert_match version.to_s, dat
  ensure
    Process.kill(15, lookupd)
    Process.kill(15, d)
    Process.kill(15, admin)
    Process.kill(15, to_file)
    Process.wait lookupd
    Process.wait d
    Process.wait admin
    Process.wait to_file
  end
end
