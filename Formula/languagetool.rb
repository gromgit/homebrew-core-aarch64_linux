class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.9",
      revision: "f8931bebf2f654974620baa179ce856f94dc776a"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2831fd09e7f8c64a12c5292d6f7e8864a92001516b71e33e82ee5ffd81166760"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f79d56a4e846aa59f7b46530f11d14cdc73e8551fba2d51d144fa8a7357002e"
    sha256 cellar: :any_skip_relocation, monterey:       "5e5d57f0b5741976fc58927498cc8a71de4d846fc336f71f42a22138aa7d2b3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9929cedd8f5632101e4b71eea5ccb69dd0f5ff94698aad9eaf0edf3193806ea3"
    sha256 cellar: :any_skip_relocation, catalina:       "b9717fbbfdc8bbf42053ffc01f7bde2cbedb5960474a848c5ec8043ae4d9e1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25e2b80d402d560f6f5c0c456c36348b28340f6c22e02225a66157026655d6e"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    java_version = "11"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool", java_version: java_version
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui", java_version: java_version
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
  end

  service do
    run [bin/"languagetool-server", "--port", "8081", "--allow-origin"]
    keep_alive true
    log_path var/"log/languagetool/languagetool-server.log"
    error_log_path var/"log/languagetool/languagetool-server.log"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Homebrew, this is an test
    EOS
    output = shell_output("#{bin}/languagetool -l en-US test.txt 2>&1")
    assert_match(/Message: Use \Wa\W instead of \Wan\W/, output)
  end
end
