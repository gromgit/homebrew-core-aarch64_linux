class RedisAT32 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-3.2.13.tar.gz"
  sha256 "862979c9853fdb1d275d9eb9077f34621596fec1843e3e7f2e2f09ce09a387ba"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/redis@3.2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0f6c694c8f7434f26e8b5e44996e95752136342a48ab2210e28f74f86d62f69f"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-04-30", because: :versioned_formula

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf", "--daemonize no"]
    keep_alive true
    working_dir var
    log_path var/"log/redis.log"
    error_log_path var/"log/redis.log"
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
