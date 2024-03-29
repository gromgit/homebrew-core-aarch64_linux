class H2o < Formula
  desc "HTTP server with support for HTTP/1.x and HTTP/2"
  homepage "https://github.com/h2o/h2o/"
  url "https://github.com/h2o/h2o/archive/v2.2.6.tar.gz"
  sha256 "f8cbc1b530d85ff098f6efc2c3fdbc5e29baffb30614caac59d5c710f7bda201"
  license "MIT"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/h2o"
    sha256 aarch64_linux: "6031c55208c5d0f6841338ecd9d9ad4511f05af1874d44aa57560dd60f2855ed"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    # https://github.com/Homebrew/brew/pull/251
    ENV.delete("SDKROOT")

    system "cmake", *std_cmake_args,
                    "-DWITH_BUNDLED_SSL=OFF",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"

    (etc/"h2o").mkpath
    (var/"h2o").install "examples/doc_root/index.html"
    # Write up a basic example conf for testing.
    (buildpath/"brew/h2o.conf").write conf_example
    (etc/"h2o").install buildpath/"brew/h2o.conf"
    pkgshare.install "examples"
  end

  # This is simplified from examples/h2o/h2o.conf upstream.
  def conf_example(port = 8080)
    <<~EOS
      listen: #{port}
      hosts:
        "127.0.0.1.xip.io:#{port}":
          paths:
            /:
              file.dir: #{var}/h2o/
    EOS
  end

  def caveats
    <<~EOS
      A basic example configuration file has been placed in #{etc}/h2o.

      You can find fuller, unmodified examples in #{opt_pkgshare}/examples.
    EOS
  end

  service do
    run [opt_bin/"h2o", "-c", etc/"h2o/h2o.conf"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"h2o.conf").write conf_example(port)
    fork do
      exec "#{bin}/h2o -c #{testpath}/h2o.conf"
    end
    sleep 2

    assert_match "Welcome to H2O", shell_output("curl localhost:#{port}")
  end
end
