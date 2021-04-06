class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/5.292.5.tar.gz"
  sha256 "18c2a8d1af4afd7245fab7fe60f46d6b80a984d23596b053da71f7ef53f68caa"
  license "GPL-2.0-only"

  depends_on "openjdk" => :test
  depends_on arch: :x86_64
  depends_on "python@3.9"

  resource("testdata") do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-21.0.0.2.tar.gz"
    sha256 "fcb144de48bb280f7d7f6013611509676d9af4bff6607fe7aa73495f16b339b7"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.9"].opt_bin}/python3"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"

    testpath.install resource("testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
