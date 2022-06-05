class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.12.tar.gz"
  sha256 "f43a7ea7f71db896338224b32f5e534951a976f13b7ef7a4fb5f5aed9f57883f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/beanstalkd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e713cf23e17aaef16dc330c09f9aa67feab30d07a83d1d699112b34befe64458"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run opt_bin/"beanstalkd"
    keep_alive true
    working_dir var
    log_path var/"log/beanstalkd.log"
    error_log_path var/"log/beanstalkd.log"
  end

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end
