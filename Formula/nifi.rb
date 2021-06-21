class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.13.2/nifi-1.13.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.13.2/nifi-1.13.2-bin.tar.gz"
  sha256 "1d4f5315e8bc04f68628e797cc1c674e8546d67e780e1a7fbdea9ca10a39cd2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6d706bd32d88aff01c78bc7c9447dbe104731aeb6698f7a1fe08c95b91d58d8e"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
