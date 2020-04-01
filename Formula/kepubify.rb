class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.1.tar.gz"
  sha256 "500f8711cb8e9023d3e6534e0ff769ebfb8d05377e9d8f6ae20cad74e903c753"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4354d7623d0cb61775d45d8d06b1cdf990ffc3d0719d894bb275b6b760b91d0c" => :catalina
    sha256 "dfd7feb98fb7da3ae9a039e6856c39339b456e9f8a1d0b69540fa60aef028506" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
