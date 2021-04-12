class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/5.292.7.tar.gz"
  sha256 "f226a0d1a20bd0bd00b8458a1e9e9433dbc448934f0aebda9d0513ac6ffe4a8e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f2035f271c2949f9a19231548eda75790b1035371105c9eba6e2579e32aac9bb"
    sha256 cellar: :any_skip_relocation, catalina: "4e5d81fca3128deefebc8ef30540e6123ea649af18a23a7ef40ca8a8015abe0a"
    sha256 cellar: :any_skip_relocation, mojave:   "7c9b32afc2aedb7478704a7a2487df11f0566f9dfac15c598578a6917661b5c1"
  end

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
