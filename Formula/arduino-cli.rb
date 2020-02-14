class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.8.0",
     :revision => "64c501da0f4c72c3dfadc081f7aa83cae99958c8"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c404773b4d48136e434179c1c6fe03cb0d5dbc1beaa7eceed9c0e270baa80d98" => :catalina
    sha256 "42852d54693a1811ed5e43961ec267f0dd1d2582848308547f3f041f45f6cfa7" => :mojave
    sha256 "f7fe16d5a2c951c5e9722e23dbaf015965a3c4800cf8a35c107ee1a2c12c1592" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags",
           "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} " \
           "-X github.com/arduino/arduino-cli/version.commit=#{commit}",
           "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")
  end
end
