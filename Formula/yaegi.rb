class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.4.tar.gz"
  sha256 "ea6a4137aeb0dc38ebf052359578cfe4a6790569b5e0cc49683412cf7b04aa12"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "feec0db4f87ae008071ed62f247236a1023bb05c61bd816eaa45feb1d7ccf375" => :catalina
    sha256 "b70a61302fc437ebb118832bba5ba0adcfc9f6fa99e241f0bd055f1f1817a4e2" => :mojave
    sha256 "3f833210c0a544381a52b3bd7c83541b82124f576a977b5d77365d69412121b1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
