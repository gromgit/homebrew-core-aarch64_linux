class RedisAT40 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://github.com/antirez/redis/archive/4.0.14.tar.gz"
  sha256 "3b8c6ea4c9db944fe6ec427c1b11d912ca6c5c5e17ee4cfaea98bbda90724752"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/redis@4.0"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "03cb4943b795f2ef9ef9ce981b40fe3be6c8b1b633a96bd6d2da251accb7980a"
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
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
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
