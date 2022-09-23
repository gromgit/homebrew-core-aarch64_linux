class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.23.3.tar.gz"
  sha256 "959ceba01012ccda55b2b5641df8684334bff1ee643faf39af80fbc72f3a2098"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "686564637671c063b8f4f2e307cc7feb5e7714d1910048e0c8857d83c11b0577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76fd3884e36ac4603151bf990c67917844833e9e019ea30c61e4e3a01330b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "ba4aa7a6c0b6780000e9a55a6b9a04c7e9de985e90cc3ba3eb5b294a384a065d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b12324c8e4e69c9f8d988918d06873642a1b12154287aac1ba64542759005c8f"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("license-plist --suppress-opening-directory")
  end
end
