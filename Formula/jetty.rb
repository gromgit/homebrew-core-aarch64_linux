class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.47.v20220610/jetty-distribution-9.4.47.v20220610.tar.gz"
  version "9.4.47.v20220610"
  sha256 "2f67259ce889d0a74cd554df8739afc930851c2d1e2bdce5d690b2f6f1d1588d"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "a42ad239f5c7748366bdb58c9bbcf9afc7648e45e5cfecf005ef138fd076df9e"
    sha256 cellar: :any,                 big_sur:      "a42ad239f5c7748366bdb58c9bbcf9afc7648e45e5cfecf005ef138fd076df9e"
    sha256 cellar: :any,                 catalina:     "a42ad239f5c7748366bdb58c9bbcf9afc7648e45e5cfecf005ef138fd076df9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b0ac7389c719a987b2ae6524c39df9a50f6c16e2748e78e3c3ffceb663bc846a"
  end

  # Ships a pre-built x86_64-only `libsetuid-osx.so`.
  depends_on arch: :x86_64
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    env = Language::Java.overridable_java_home_env
    env["JETTY_HOME"] = libexec
    Dir.glob(libexec/"bin/*.sh") do |f|
      (bin/File.basename(f, ".sh")).write_env_script f, env
    end
  end

  test do
    http_port = free_port
    ENV["JETTY_ARGS"] = "jetty.http.port=#{http_port} jetty.ssl.port=#{free_port}"
    ENV["JETTY_BASE"] = testpath
    ENV["JETTY_RUN"] = testpath
    cp_r Dir[libexec/"demo-base/*"], testpath

    log = testpath/"jetty.log"
    pid = fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      exec bin/"jetty", "run"
    end

    begin
      sleep 20 # grace time for server start
      assert_match "webapp is deployed. DO NOT USE IN PRODUCTION!", log.read
      assert_match "Welcome to Jetty #{version.major}", shell_output("curl --silent localhost:#{http_port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
