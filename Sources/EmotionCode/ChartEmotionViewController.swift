import UIKit

final class ChartEmotionViewController: UICollectionViewController {

    private var emotionDescription: String!

    private var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    func set(_ emotion: Chart.Emotion) {
        navigationItem.title = emotion.title
        emotionDescription = emotion.description
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        itemCell.addEmotionDescriptionView(withDescription: emotionDescription)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        showDescriptionAlongsideTransition()
        setDescriptionSizeAlongsideTransition(with: transitionCoordinator)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chartLayout.core.viewWillTransition()
    }

    // MARK: Layout

    private func showDescriptionAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [itemCell] _ in
            itemCell.setEmotionDescriptionVisible(true)
        }, completion: nil)
    }

    private func setDescriptionSizeAlongsideTransition(with coordinator: UIViewControllerTransitionCoordinator?) {
        coordinator?.animate(alongsideTransition: { [itemCell, collectionView, chartLayout] _ in
            let indexPath = collectionView!.indexPath(for: itemCell)!
            let size = chartLayout.core.view.items[indexPath]!.frame.size
            itemCell.setEmotionDescriptionSize(to: size.cgSize)
        }, completion: nil)
    }

    private func layoutCellsAlongsideTransition() {
        transitionCoordinator?.animate(alongsideTransition: { [collectionView] _ in
            collectionView!.visibleCells.forEach { $0.layoutIfNeeded() }
        }, completion: { [chartLayout] context in
            guard !context.isCancelled else { return }
            chartLayout.core.viewDidTransition()
            chartLayout.invalidateLayout()
        })
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chartLayout.core.systemDidSet(viewSize: .init(cgSize: size))
        setDescriptionSizeAlongsideTransition(with: coordinator)
    }

    // MARK: Cell

    private var itemCell: ItemCollectionViewCell {
        let indexPath = collectionView!.indexPathForSelectedItem!
        return collectionView!.cellForItem(at: indexPath) as! ItemCollectionViewCell
    }

}

extension ChartEmotionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutCore.Mode {
        let selectedIndexPath = collectionView.indexPathForSelectedItem!
        return .emotion(selectedIndexPath, isFocused: false)
    }

}
