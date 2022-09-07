class Texapp < Formula
  desc "App.net client based on TTYtter"
  homepage "https://www.floodgap.com/software/texapp/"
  url "https://www.floodgap.com/software/texapp/dist0/0.6.11.txt"
  sha256 "03c3d5475dfb7877000ce238d342023aeab3d44f7bac4feadc475e501aa06051"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/texapp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7659a15a050f1cf6b87d606db26789b75ff6d7649d11b1785bbb9ad92b397d61"
  end

  def install
    bin.install "#{version}.txt" => "texapp"
  end

  test do
    assert_match "trying to find cURL ...", pipe_output("#{bin}/texapp", "^C")
  end
end
