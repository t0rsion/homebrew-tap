class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "4c06ee2d7123e2b290a56cf74bdf209b9679e6836d3d2b716ecc719b95d7691b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "6ad5e97c56aef755aff00fa5e2013e20d7662c2658d3e24b4f1093999fb5b8f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca27d9e70fc23743d88758aa39cf0f78a685f73a57fef85fc466eb666df3c477"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.7.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3c4dc4886c44ae894ee51208991c3e457cf82fadfff2bb6d98a21b64dbd925e"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "holos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "holos"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
